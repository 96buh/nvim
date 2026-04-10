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

vim.cmd("packadd nvim.undotree")
map("n", "<leader>u", require("undotree").open)
