return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "jay-babu/mason-nvim-dap.nvim",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -------------------------------------------------
      -- ✅ 延迟 Mason 加载，避免循环 require
      -------------------------------------------------
      vim.schedule(function()
        require("mason-nvim-dap").setup({
          ensure_installed = { "codelldb" },
          automatic_installation = true,
          handlers = {},
        })
      end)

      -------------------------------------------------
      -- ✅ UI 设置
      -------------------------------------------------
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -------------------------------------------------
      -- ✅ codelldb 适配器
      -------------------------------------------------
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      -------------------------------------------------
      -- 🚀 C/C++ 调试配置（带自动编译）
      -------------------------------------------------
      local function compile_current()
        local file = vim.fn.expand("%:p")
        local output = vim.fn.expand("%:p:r")
        local ext = vim.fn.expand("%:e")
        if ext == "cpp" then
          vim.fn.system(string.format("g++ -std=c++20 -g '%s' -o '%s'", file, output))
        elseif ext == "c" then
          vim.fn.system(string.format("gcc -std=c11 -g '%s' -o '%s'", file, output))
        end
      end

      dap.configurations.cpp = {
        {
          name = "Launch (C++20)",
          type = "codelldb",
          request = "launch",

          program = function()
            compile_current()
            local exe = vim.fn.expand("%:p:r")
            return vim.fn.filereadable(exe) == 1 and exe
              or vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,

          cwd = "${workspaceFolder}",
          stopOnEntry = false,

          -- 🔴 关键三行
          console = "integratedTerminal",
          terminal = "integrated",
          runInTerminal = true,
        },
      }
      dap.configurations.c = dap.configurations.cpp
    end,
  },
}
