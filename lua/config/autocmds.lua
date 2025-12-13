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

    -- terminal / term:// buffer，一律踢掉 LSP
    if bt == "terminal" or name:match("^term://") then
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        vim.schedule(function()
          client.stop()
        end)
      end
    end
  end,
})
