return {
	{
		"nvim-flutter/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- optional for vim.ui.select
		},
		config = function()
			require("flutter-tools").setup({
				decorations = {
					statusline = {
						app_version = false,
						device = true,
						project_config = false,
					},
				},
				lsp = {
					color = {
						enabled = true,
						background = false,
						background_color = nil,
						foreground = true,
						virtual_text = true,
						virtual_text_str = "■",
					},
					settings = {
						showTodos = true,
					},
				},
			})
		end,
	},
}
