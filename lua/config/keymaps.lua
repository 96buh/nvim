-- 使用Visual Mode選取後按住shift可以把程式往上或往下移動
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- 使用貼上覆蓋文字時，不會複製要被覆蓋的文字
vim.keymap.set("x", "<leader>p", '"_dP')
