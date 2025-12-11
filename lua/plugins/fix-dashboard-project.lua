return {
  -- 1. 禁用旧插件
  { "ahmedkhalf/project.nvim", enabled = false },

  -- 2. 安装新插件
  {
    "nvim-telescope/telescope-project.nvim",
    event = "VeryLazy",
    config = function()
      require("telescope").load_extension("project")
    end,
  },

  -- 3. 配置扫描路径
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts.extensions = opts.extensions or {}
      opts.extensions.project = {
        base_dirs = {
          { path = "~/Documents", max_depth = 4 }, -- 你的代码目录
        },
        hidden_files = true,
        theme = "dropdown",
        sync_with_nvim_tree = true,
      }
    end,
  },

  -- 4. 修复主页按钮 + 恢复颜色
  {
    "goolord/alpha-nvim",
    opts = function(_, dashboard)
      -- 🔥 关键修复：定义一个辅助函数，给按钮加上高亮颜色
      local function button(sc, txt, keybind, keybind_opts)
        local b = dashboard.button(sc, txt, keybind, keybind_opts)
        b.opts.hl = "AlphaButtons" -- 恢复按钮文字颜色
        b.opts.hl_shortcut = "AlphaShortcut" -- 恢复快捷键颜色
        return b
      end

      -- 使用带颜色的 button 函数重写列表
      dashboard.section.buttons.val = {
        button("f", " " .. " Find file", ":Telescope find_files <CR>"),
        button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
        button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),

        -- 你的 Projects 按钮（现在也有颜色了！）
        button("p", " " .. " Projects", ":Telescope project <CR>"),

        button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
        button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
        button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
        button("l", "󰒲 " .. " Lazy", ":Lazy <CR>"),
        button("q", " " .. " Quit", ":qa<CR>"),
      }
      return dashboard
    end,
  },
}
