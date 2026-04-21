return {
  "nickjvandyke/opencode.nvim",
  version = "*",
  dependencies = {
    {
      "folke/snacks.nvim",
      optional = true,
      opts = {
        input = {},
        picker = {
          actions = {
            opencode_send = function(...)
              return require("opencode").snacks_picker_send(...)
            end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
          },
        },
      },
    },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- 使用默认配置即可，opencode.nvim 会自动找到运行中的 opencode 实例
      -- 如果找不到，会启动一个内嵌终端运行 opencode --port
    }

    -- 自动重载 opencode 编辑的文件
    vim.o.autoread = true

    -- ── Keymaps ──────────────────────────────────────────────
    -- <leader>o 作为 opencode 前缀，避免和 CodeCompanion (<leader>c) 冲突

    -- 核心操作
    vim.keymap.set({ "n", "x" }, "<leader>oa", function()
      require("opencode").ask("@this: ", { submit = true })
    end, { desc = "Ask opencode" })

    vim.keymap.set({ "n", "x" }, "<leader>os", function()
      require("opencode").select()
    end, { desc = "Opencode select" })

    vim.keymap.set({ "n", "t" }, "<leader>oo", function()
      require("opencode").toggle()
    end, { desc = "Toggle opencode" })

    -- Operator（支持 motion 和 dot-repeat）
    vim.keymap.set({ "n", "x" }, "go", function()
      return require("opencode").operator("@this ")
    end, { desc = "Send range to opencode", expr = true })

    vim.keymap.set("n", "goo", function()
      return require("opencode").operator("@this ") .. "_"
    end, { desc = "Send line to opencode", expr = true })

    -- 快捷 prompt
    vim.keymap.set({ "n", "x" }, "<leader>or", function()
      require("opencode").prompt("review")
    end, { desc = "Opencode review" })

    vim.keymap.set({ "n", "x" }, "<leader>oe", function()
      require("opencode").prompt("explain")
    end, { desc = "Opencode explain" })

    vim.keymap.set({ "n", "x" }, "<leader>of", function()
      require("opencode").prompt("fix")
    end, { desc = "Opencode fix diagnostics" })

    vim.keymap.set({ "n", "x" }, "<leader>ot", function()
      require("opencode").prompt("test")
    end, { desc = "Opencode add tests" })

    vim.keymap.set({ "n", "x" }, "<leader>od", function()
      require("opencode").prompt("diff")
    end, { desc = "Opencode review diff" })

    vim.keymap.set({ "n", "x" }, "<leader>oi", function()
      require("opencode").prompt("implement")
    end, { desc = "Opencode implement" })

    -- 滚动 opencode 消息
    vim.keymap.set("n", "<S-C-u>", function()
      require("opencode").command("session.half.page.up")
    end, { desc = "Scroll opencode up" })

    vim.keymap.set("n", "<S-C-d>", function()
      require("opencode").command("session.half.page.down")
    end, { desc = "Scroll opencode down" })
  end,
}
