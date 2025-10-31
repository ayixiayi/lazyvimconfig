return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      -- 打开方式：水平分屏
      direction = "horizontal",

      -- 默认大小（行数）
      size = 15,

      -- 使用 <leader>tt 打开/关闭终端
      open_mapping = [[<leader>tt]],

      -- 程序退出后关闭终端
      close_on_exit = true,

      -- 显示 shading 效果（略微暗一点）
      shade_terminals = true,
    })
  end,
}
