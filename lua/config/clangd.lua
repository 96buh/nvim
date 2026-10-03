local M = {}

local function is_file(path)
	local stat = path and (vim.uv or vim.loop).fs_stat(path)
	return stat and stat.type == "file"
end

local function add_candidate(candidates, path)
	if not path or path == "" then
		return
	end

	path = vim.fs.normalize(vim.fn.expand(path))
	if path:match("compile_commands%.json$") then
		table.insert(candidates, path)
	else
		table.insert(candidates, vim.fs.joinpath(path, "compile_commands.json"))
	end
end

local function add_glob(candidates, root_dir, pattern)
	for _, path in ipairs(vim.fn.globpath(root_dir, pattern, false, true)) do
		table.insert(candidates, vim.fs.normalize(path))
	end
end

local function is_llvm_project(root_dir)
	return root_dir
		and is_file(vim.fs.joinpath(root_dir, "llvm", "CMakeLists.txt"))
		and is_file(vim.fs.joinpath(root_dir, "clang", "CMakeLists.txt"))
end

---Find an LLVM/CMake compilation database without recursively walking the
---(very large) source tree. Set `vim.g.llvm_build_dir` or `$LLVM_BUILD_DIR`
---when the build directory is not inside the repository.
---@param root_dir string?
---@return string? directory
---@return string? database
function M.find_compile_commands(root_dir)
	local candidates = {}
	-- An LLVM-specific override must not leak into unrelated C++ projects.
	if not root_dir or is_llvm_project(root_dir) then
		add_candidate(candidates, vim.g.llvm_build_dir)
		add_candidate(candidates, vim.env.LLVM_BUILD_DIR)
	end

	if root_dir and root_dir ~= "" then
		add_candidate(candidates, root_dir)
		add_glob(candidates, root_dir, "build*/compile_commands.json")
		add_glob(candidates, root_dir, "cmake-build-*/compile_commands.json")
		add_glob(candidates, root_dir, "out/*/compile_commands.json")
	end

	local seen = {}
	for _, database in ipairs(candidates) do
		if not seen[database] and is_file(database) then
			return vim.fs.dirname(database), database
		end
		seen[database] = true
	end
end

function M.config()
	return {
		cmd = function(dispatchers, config)
			local cmd = {
				"clangd",
				"--background-index",
				"--completion-style=detailed",
				"--header-insertion=never",
				"--fallback-style=LLVM",
			}
			local compile_commands_dir = M.find_compile_commands(config.root_dir)
			if compile_commands_dir then
				table.insert(cmd, "--compile-commands-dir=" .. compile_commands_dir)
			end

			return vim.lsp.rpc.start(cmd, dispatchers, {
				cwd = config.cmd_cwd or config.root_dir,
				env = config.cmd_env,
				detached = config.detached,
			})
		end,
	}
end

function M.setup_info_command()
	vim.api.nvim_create_user_command("ClangdInfo", function()
		local clients = vim.lsp.get_clients({ bufnr = 0, name = "clangd" })
		local client = clients[1]
		local root_dir = client and client.root_dir or vim.fs.root(0, { ".clangd", "compile_commands.json", ".git" })
		local _, database = M.find_compile_commands(root_dir)

		local lines = {
			"Executable: " .. (vim.fn.exepath("clangd") ~= "" and vim.fn.exepath("clangd") or "not found"),
			"Project root: " .. (root_dir or "not detected"),
			"Compilation database: " .. (database or "not found"),
		}

		if not database then
			table.insert(lines, "")
			table.insert(lines, "Generate it with CMake, then run :LspRestart.")
			table.insert(lines, "For an external build directory, set $LLVM_BUILD_DIR or vim.g.llvm_build_dir.")
		end

		vim.notify(table.concat(lines, "\n"), database and vim.log.levels.INFO or vim.log.levels.WARN, {
			title = "clangd / LLVM",
		})
	end, { desc = "Show clangd executable and LLVM compilation database", force = true })
end

return M
