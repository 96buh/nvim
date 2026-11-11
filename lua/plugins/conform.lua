return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = { "n", "x" },
			desc = "Format buffer or selection",
		},
	},
	opts = {
		format_on_save = function(bufnr)
			local filetype = vim.bo[bufnr].filetype
			if filetype == "c" or filetype == "cpp" then
				-- Only format on save when the project declares its C/C++ style.
				local filename = vim.api.nvim_buf_get_name(bufnr)
				if filename == "" or not vim.fs.root(filename, { ".clang-format", "_clang-format" }) then
					return nil
				end
			end
			return {
				timeout_ms = 2000,
				lsp_format = "fallback",
			}
		end,
		formatters = {
			latexindent = {
				prepend_args = { "-l", "-m" },
			},
		},
		formatters_by_ft = {
			c = { "clang-format", lsp_format = "never" },
			cpp = { "clang-format", lsp_format = "never" },
			lua = { "stylua" },
			nix = { "alejandra" },
			python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
			rust = { "rustfmt", lsp_format = "fallback" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			json = { "prettierd", "prettier", stop_after_first = true },
			jsonc = { "prettierd", "prettier", stop_after_first = true },
			markdown = { "prettier" },
			yaml = { "prettier" },
			yml = { "prettier" },
			html = { "prettier" },
			liquid = { "prettier" },
			tex = { "latexindent" },
		},
	},
}
