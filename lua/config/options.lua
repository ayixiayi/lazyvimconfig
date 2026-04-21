-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_leader_check = false
vim.opt.wrap = true
-- 强制 Buffer 栏 (Tabline) 永远显示，即使只有一个文件
vim.opt.showtabline = 2
vim.opt.clipboard = "unnamedplus"
