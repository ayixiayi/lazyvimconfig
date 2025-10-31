return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha", -- 💡 这是暗色版本
      transparent_background = false,
      term_colors = true,
      integrations = {
        treesitter = true,
        native_lsp = { enabled = true },
        snacks = true,
        cmp = true,
        gitsigns = true,
        telescope = true,
        notify = true,
        mini = true,
        which_key = true,
        dap = { enabled = true, enable_ui = true },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin", -- 🚀 默认主题设置
    },
  },
}
