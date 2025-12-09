return {
  -- 1. copilot 本体
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    config = function()
      require("copilot").setup({
        panel = { enabled = false },
        suggestion = {
          enabled = true,
          auto_trigger = false,
          debounce = 75,
          keymap = {
            accept = "<C-F>",
            next = "<C-G>",
            prev = "<C-D>",
            dismiss = "<C-/>",
          },
        },
        filetypes = {
          lua = true,
          python = true,
          cpp = true,
          c = true,
          sh = true,
          bash = true,
          zsh = true,
          tex = true,
          javascript = true,
          typescript = true,
          markdown = false,
          gitcommit = false,
          ["*"] = true,
        },
      })
    end,
  },

  -- 2. copilot-cmp 集成
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = true, -- 就是 copilot_cmp.setup()
  },

  -- 3. 在 cmp 那边把 copilot 这个 source 插进去
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      -- 插到最前面，优先级高
      table.insert(opts.sources, 1, { name = "copilot", group_index = 2 })
    end,
  },
}
