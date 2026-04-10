return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {},
		config = function(_, opts)
			require("gitsigns").setup(opts)
			vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
		end,
	},
}
