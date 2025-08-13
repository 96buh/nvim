return {
	{
		"tpope/vim-fugitive",
		config = function()
			local map = vim.keymap.set

			-- status
			map("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })

			-- verticle diff
			map("n", "<leader>gD", vim.cmd.Gvdiffsplit, { desc = "Git vertical diff" })
		end,
	},
}
