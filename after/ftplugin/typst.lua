vim.opt_local.spell = true
vim.opt_local.spelllang = { "en_us", "cjk" }
vim.opt_local.linebreak = true
vim.opt_local.wrapmargin = 5
vim.opt_local.formatoptions:append("t")

local export_cmd = {
	pdf = "tinymist.exportPdf",
	png = "tinymist.exportPng",
	svg = "tinymist.exportSvg",
	html = "tinymist.exportHtml",
	md = "tinymist.exportMarkdown",
	tex = "tinymist.exportTeX",
}

local function export(fmt)
	local cmd = export_cmd[fmt or "pdf"]
	if not cmd then
		return
	end
	local params = {
		command = cmd,
		arguments = { vim.api.nvim_buf_get_name(0), { outputPath = "$root/target/$dir/$name" } },
	}
	vim.lsp.buf_request(0, "workspace/executeCommand", params, function(err)
		if err then
			vim.notify("tinymist export failed: " .. (err.message or tostring(err)), vim.log.levels.ERROR)
		end
	end)
end

-- telescope export menu
local function export_menu()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local conf = require("telescope.config").values

	local items = { "pdf", "png", "svg", "html", "md", "tex" }

	pickers
		.new({}, {
			prompt_title = "Typst export",
			finder = finders.new_table({
				results = items,
				entry_maker = function(fmt)
					return { value = fmt, display = fmt:upper(), ordinal = fmt }
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(bufnr, map)
				local run = function()
					local e = action_state.get_selected_entry()
					actions.close(bufnr)
					export(e and e.value or "pdf")
				end
				map("i", "<CR>", run)
				map("n", "<CR>", run)
				return true
			end,
		})
		:find()
end

vim.keymap.set("n", "<localleader>v", function()
	vim.cmd("TypstPreviewStop")
	vim.cmd("TypstPreview")
end, { buffer = true, desc = "Typst Preview" })

vim.keymap.set("n", "<localleader>c", function()
	export("pdf")
end, { buffer = true })

vim.keymap.set("n", "<localleader>cm", export_menu, { buffer = true })
