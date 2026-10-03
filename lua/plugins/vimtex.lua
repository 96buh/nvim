return {
	"lervag/vimtex",
	lazy = false,
	keys = {
		{ "dsm", "<Plug>(vimtex-env-delete-math)", ft = "tex", desc = "Delete math env" },
		{ "ai", "<Plug>(vimtex-am)", mode = { "o", "x" }, ft = "tex", desc = "VimTeX item" },
		{ "ii", "<Plug>(vimtex-im)", mode = { "o", "x" }, ft = "tex", desc = "VimTeX item inner" },
		{ "am", "<Plug>(vimtex-a$)", mode = { "o", "x" }, ft = "tex", desc = "VimTeX inline math" },
		{ "im", "<Plug>(vimtex-i$)", mode = { "o", "x" }, ft = "tex", desc = "VimTeX inline math inner" },
		{ "<leader>wc", "<Cmd>VimtexCountWords<CR>", ft = "tex", desc = "Count Words" },
		{ "<localleader>c", "<Cmd>update<CR><Cmd>VimtexCompileSS<CR>", ft = "tex", desc = "Compile Single Shot" },
		{ "<localleader>v", "<Plug>(vimtex-view)", ft = "tex", desc = "VimTeX View" },
	},
	init = function()
		-- local vimtex_fmt_group = vim.api.nvim_create_augroup("VimtexFormatOnSave", { clear = true })
		vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
			pattern = "tex",
			callback = function()
				vim.opt_local.spell = true
				vim.opt_local.spelllang = "en_us"
			end,
		})

		vim.g.vimtex_format_enabled = 0
		vim.g.vimtex_indent_enabled = 0
		vim.g.vimtex_view_method = "skim"
		vim.g.vimtex_complete_enable = 1
		vim.g.vimtex_quickfix_open_on_warning = 0
		vim.g.vimtex_compiler_method = "latexmk"

		vim.o.conceallevel = 2
		vim.g.vimtex_syntax_conceal = {
			accents = 1,
			ligatures = 1,
			cites = 1,
			fancy = 1,
			spacing = 1,
			greek = 1,
			math_bounds = 0,
			math_delimiters = 1,
			math_fracs = 1,
			math_symbols = 1,
			math_super_sub = 1,
			sections = 1,
			styles = 1,
		}
		vim.g.vimtex_syntax_custom_cmds = {
			{ name = "multiply", cmdre = "times", mathmode = 1, concealchar = "" },
		}
		vim.g.vimtex_compiler_latexmk = {
			aux_dir = "temp",
			options = {
				"-verbose",
				"-file-line-error",
				"-synctex=1",
				"-interaction=nonstopmode",
				"-shell-escape",
				"-lualatex",
			},
		}

		-- vim.api.nvim_create_autocmd("BufWritePre", {
		-- 	group = vimtex_fmt_group,
		-- 	pattern = "*.tex",
		-- 	callback = function()
		-- 		local save_cursor = vim.fn.getpos(".")
		-- 		vim.cmd([[:normal! gg=G]])
		-- 		vim.fn.setpos(".", save_cursor)
		-- 	end,
		-- })
	end,
}
