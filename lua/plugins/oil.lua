return {
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		lazy = false,
		keys = {
			{ "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
		},
		config = function()
			require("oil").setup({
				view_options = {
					show_hidden = true,
					is_hidden_file = function(name, bufnr)
						local m = name:match("^%.")
						return m ~= nil
					end,
				},
			})
		end,
	},
}
