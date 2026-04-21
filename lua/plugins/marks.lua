return {
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {
      default_mappings = false,
      signs = true,
      mappings = {
        set = "m",
        set_next = "m,",
        toggle = "m;",
        next = "m]",
        prev = "m[",
        preview = "m:",
      },
    },
    keys = {
      {
        "<leader>md",
        function()
          require("marks").delete()
        end,
        desc = "Delete mark (press letter)",
      },
      {
        "<leader>ml",
        function()
          require("marks").delete_line()
        end,
        desc = "Delete all marks on line",
      },
      {
        "<leader>ma",
        function()
          require("marks").delete_buf()
        end,
        desc = "Delete all marks in buffer",
      },
    },
  },
}
