-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
-- -- ===============================
-- 禁止任何 LSP attach 到 terminal
-- ===============================
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf = args.buf
    local bt = vim.bo[buf].buftype
    local name = vim.api.nvim_buf_get_name(buf)

    if bt == "terminal" or name:match("^term://") then
      vim.schedule(function()
        vim.lsp.buf_detach_client(buf, args.data.client_id)
      end)
    end
  end,
})

-- =======================================================
-- 🔥 自动清除 Windows 换行符 (^M)
-- =======================================================
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  callback = function()
    -- 如果文件是可修改的
    if not vim.bo.binary and vim.bo.modifiable then
      -- 1. 保存当前光标位置 (防止替换后光标乱跳)
      local view = vim.fn.winsaveview()
      -- 2. 强行把文件格式设为 unix (LF)
      vim.bo.fileformat = "unix"
      -- 3. 搜索并替换掉所有的 \r (即 ^M)，silent! 使得找不到时也不报错
      vim.cmd("silent! %s/\\r//ge")
      -- 4. 恢复光标位置
      vim.fn.winrestview(view)
    end
  end,
})
