return {
  -- ========================================================
  -- 1. 禁用插件区 (消除报错)
  -- ========================================================
  { "nvim-mini/mini.starter", enabled = false }, -- 禁用新名字
  { "goolord/alpha-nvim", enabled = false },
  { "nvimdev/dashboard-nvim", enabled = false },

  -- ========================================================
  -- 2. 【关键修复】把丢失的 Project 插件装回来！
  -- ========================================================
  {
    "nvim-telescope/telescope-project.nvim",
    event = "VeryLazy",
    config = function()
      require("telescope").load_extension("project")
    end,
  },
  -- 配置 Project 扫描路径
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts.extensions = opts.extensions or {}
      opts.extensions.project = {
        base_dirs = {
          { path = "~/Documents", max_depth = 4 }, -- 你的代码目录，按需修改
        },
        hidden_files = true,
        theme = "dropdown",
        sync_with_nvim_tree = true,
      }
    end,
  },

  -- ========================================================
  -- 3. 启用 Snacks Dashboard (主页按钮配置)
  -- ========================================================
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },

            -- 🔥 现在这个按钮能用了，因为上面第2步把插件装回来了
            { icon = " ", key = "p", desc = "Projects", action = ":Telescope project" },

            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
      image = { enabled = true },
    },
  },
}
