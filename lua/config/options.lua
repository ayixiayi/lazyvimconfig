-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- 这是你已经有的 Leader 键设置
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- 🔥 关键：添加这个选项，让 LazyVim 停止检查！
vim.g.lazyvim_leader_check = false
vim.opt.wrap = true
-- 强制 Buffer 栏 (Tabline) 永远显示，即使只有一个文件
vim.opt.showtabline = 2
