return {
  {
    "milanglacier/minuet-ai.nvim",
    config = function()
      require("minuet").setup({
        notify = "error",
        provider = "gemini",
        throttle = 500,
        n_completions = 3,
        virtualtext = {
          auto_trigger_ft = { "*" },
          keymap = {
            accept = "<C-f>",
          },
        },
        provider_options = {
          gemini = {
            model = "gemini-3-flash-preview",
            api_key = function()
              return os.getenv("GEMINI_API_KEY") or ""
            end,
            stream = true,
            optional = {
              generationConfig = {
                maxOutputTokens = 128,
                thinkingConfig = {
                  thinkingBudget = 0,
                },
              },
            },
          },
        },
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          local vt = require("minuet.virtualtext")
          vim.keymap.set("i", "<C-f>", vt.action.accept, { silent = true })
          vim.keymap.set("i", "<C-e>", vt.action.next, { silent = true })
          vim.keymap.set("i", "<C-d>", vt.action.prev, { silent = true })
          vim.keymap.set("i", "<C-x>", vt.action.dismiss, { silent = true })
        end,
      })
    end,
  },

  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = opts.keymap or {}
      opts.keymap["<CR>"] = { "fallback" }
      opts.keymap["<Tab>"] = {
        "select_and_accept",
        "snippet_forward",
        "fallback",
      }
      opts.keymap["<S-Tab>"] = { "snippet_backward", "fallback" }
    end,
  },
}
