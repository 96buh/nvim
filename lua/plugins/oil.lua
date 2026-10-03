return {
	"stevearc/oil.nvim",
	dependencies = { { "nvim-mini/mini.icons", opts = {} } },
	lazy = false,
	keys = {
		{ "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
	},
	config = function()
		require("oil").setup({
			view_options = {
				show_hidden = true,
				sort = {
					{ "type", "asc" },
					{ "name", "asc" },
				},
			},
		})
	end,
}
