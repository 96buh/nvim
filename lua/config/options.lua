vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"

vim.o.clipboard = "unnamedplus"

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.wrap = false

vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.o.undofile = true

vim.o.hlsearch = false
vim.o.incsearch = true

vim.o.scrolloff = 8

vim.o.updatetime = 50

vim.opt.fillchars:append({ eob = " " })
vim.o.termguicolors = true

vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
