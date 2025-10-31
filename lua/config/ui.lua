return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.theme = "catppuccin" -- 让状态栏配合 theme
      opts.sections.lualine_b = { "branch", "diff", "diagnostics" }
    end,
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#1e1e2e",
      timeout = 3000,
    },
  },
}
