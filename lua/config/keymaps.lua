local map = vim.keymap.set

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map("x", "<leader>p", '"_dP')
map("n", "<leader>sp", "1z=")
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

map("n", "<leader>u", function()
	pcall(vim.cmd.packadd, "nvim.undotree")
	local ok, undotree = pcall(require, "undotree")
	if not ok then
		vim.notify("Undotree is not available. Install or enable nvim.undotree first.", vim.log.levels.WARN)
		return
	end
	undotree.open()
end, { desc = "Open undo tree" })
