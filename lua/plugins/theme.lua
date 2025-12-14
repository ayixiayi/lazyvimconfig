return {
  -- 1. Cyberdream 主题插件
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false, -- 必须立即加载
    priority = 1000, -- 最高优先级
    opts = {
      transparent = true, -- 🔥 核心：开启透明
      italic_comments = true,
      hide_fillchars = true,
      borderless_telescope = true,
      extensions = {
        telescope = true,
        notify = true,
        mini = true,
        cmp = true,
        gitsigns = true,
        whichkey = true,
      },
    },
    config = function(_, opts)
      require("cyberdream").setup(opts)

      -- 🔥 关键指令：切换主题
      vim.cmd("colorscheme cyberdream")

      -- ⚡️ 暴力透明：清除所有背景色
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
    end,
  },

  -- 2. 修正状态栏 (Lualine)
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- 移除之前强制的 "catppuccin"，改为自动
      opts.theme = "auto"
    end,
  },
}
