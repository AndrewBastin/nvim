vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.editorconfig = true

vim.opt.mouse = "a"
vim.opt.confirm = true
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.tabstop = 2
vim.opt.splitright = true
vim.opt.expandtab = true
vim.opt.wrap = false

vim.wo.relativenumber = true
vim.wo.number = true

if vim.g.neovide then
	vim.o.guifont = "FiraCode Nerd Font:h14"
	vim.opt.linespace = 1
	vim.g.neovide_hide_mouse_when_typing = true
	vim.g.neovide_remember_window_size = true
end
