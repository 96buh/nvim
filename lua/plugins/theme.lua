return {
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			vim.cmd("colorscheme gruvbox")
		end,
	},
	{
		"neanias/everforest-nvim",
		version = false,
		lazy = false,
		config = function()
			require("everforest").setup({
				background = "hard",
			})
		end,
	},
}
