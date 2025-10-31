return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
    "stevearc/dressing.nvim",
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "openrouter",
        },
        inline = {
          adapter = "openrouter",
        },
      },

      adapters = {
        openrouter = function()
          return require("codecompanion.adapters").extend("openai", {
            name = "openrouter", -- ✅全新适配器标识
            env = {
              api_key = "OPENROUTER_API_KEY",
            },
            url = "https://openrouter.ai/api/v1/chat/completions",
            stream = true,

            -- ✅禁用 OpenAI 官方模型名校验
            validate = false,

            -- ✅显式声明可用模型（OpenRouter 模型列表）
            schema = {
              model = {
                default = "anthropic/claude-sonnet-4.5",
                choices = {
                  "anthropic/claude-haiku-4.5",
                  "anthropic/claude-opus-4.1",
                  "openai/gpt-5-codex",
                  "openai/gpt-5-pro",
                  "openai/gpt-5",
                },
              },
            },
          })
        end,
      },

      display = {
        chat = {
          show_settings = true, -- ✅切模型按钮
          show_header = true,
        },
      },
    })
  end,

  keys = {
    { "<leader>cc", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "AI Chat" },
    { "<leader>ca", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions" },
    { "<leader>ct", "<cmd>CodeCompanionToggle<cr>", mode = { "n", "v" }, desc = "Toggle Chat" },

    { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add Selection To Chat" },

    { "<leader>ce", "<cmd>CodeCompanion /explain<cr>", mode = "v", desc = "Explain Code" },
    { "<leader>cf", "<cmd>CodeCompanion /fix<cr>", mode = "v", desc = "Fix Code" },
    { "<leader>co", "<cmd>CodeCompanion /optimize<cr>", mode = "v", desc = "Optimize Code" },
    { "<leader>cd", "<cmd>CodeCompanion /debug<cr>", mode = "v", desc = "Debug Code" },
    { "<leader>cs", "<cmd>CodeCompanion /tests<cr>", mode = "v", desc = "Generate Tests" },

    { "<leader>cm", "<cmd>CodeCompanionChat /model<cr>", mode = "n", desc = "Switch AI Model" },
  },
}
