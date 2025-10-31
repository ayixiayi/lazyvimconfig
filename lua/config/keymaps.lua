-- ===========================
-- 基础设置（确保本文件单独加载也安全）
-- ===========================
vim.g.mapleader = vim.g.mapleader or " "
vim.g.maplocalleader = vim.g.maplocalleader or ","

-- 返回 LazyVim 首页
vim.keymap.set("n", "<leader>h", "<Cmd>Alpha<CR>", { desc = "Home Dashboard" })

-- ===========================
-- 工具函数：打开底部交互终端并运行 bash 脚本
-- ===========================
local function open_term_and_run(bash_script, opts)
  opts = opts or {}
  vim.cmd("botright 15split | enew")
  local buf = vim.api.nvim_get_current_buf()

  local job_id = vim.fn.termopen({ "bash", "-lc", bash_script }, {
    cwd = opts.cwd,
    on_exit = function(_, code, _)
      if code ~= 0 then
        vim.schedule(function()
          -- ✅安全写入终端 buffer
          if vim.api.nvim_buf_is_valid(buf) then
            local modifiable = vim.bo[buf].modifiable
            local readonly = vim.bo[buf].readonly

            -- ✅暂时放开限制
            vim.bo[buf].modifiable = true
            vim.bo[buf].readonly = false

            vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "", "❌ 进程退出码: " .. tostring(code) })

            -- ✅写完后恢复原状态
            vim.bo[buf].modifiable = modifiable
            vim.bo[buf].readonly = readonly
          end
        end)
      end
    end,
  })

  vim.cmd("startinsert")
  return job_id
end
-- ===========================
-- F5：C/C++/Python 一键编译 + 交互运行
-- ===========================
vim.keymap.set("n", "<F5>", function()
  local file = vim.fn.expand("%:p") -- 完整路径
  local dir = vim.fn.expand("%:p:h") -- 目录
  local name = vim.fn.expand("%:t:r") -- 文件名(无扩展)
  local out = vim.fn.expand("%:p:r") -- 输出可执行文件完整路径
  local ext = vim.fn.expand("%:e") -- 扩展名

  -- 保存当前文件
  pcall(vim.cmd, "w")

  local script

  if ext == "cpp" then
    script = string.format(
      [[
cd %q
clear
echo '▶️  Building %s...'
g++ -std=c++20 -O0 -g %q -o %q
ret=$?
if [ $ret -ne 0 ]; then
  echo '❌ Build failed (exit '$ret')'
  exit $ret
fi
clear
echo '🚀 Running:'
echo '=============='
exec %q
]],
      dir,
      name,
      file,
      out,
      "./" .. name
    )
  elseif ext == "c" then
    script = string.format(
      [[
cd %q
clear
echo '▶️  Building %s...'
gcc -std=c11 -O0 -g %q -o %q
ret=$?
if [ $ret -ne 0 ]; then
  echo '❌ Build failed (exit '$ret')'
  exit $ret
fi
clear
echo '🚀 Running:'
echo '=============='
exec %q
]],
      dir,
      name,
      file,
      out,
      "./" .. name
    )
  elseif ext == "py" then
    script = string.format(
      [[
cd %q
clear
echo '🚀 Running %s'
echo '=============='
exec python3 %q
]],
      dir,
      name,
      file
    )
  else
    vim.notify("不支持的文件类型：" .. ext, vim.log.levels.ERROR)
    return
  end

  open_term_and_run(script, { cwd = dir })
end, { desc = "Build & Run (交互可输入)" })

-- ===========================
-- F6：仅运行（不重新编译），适合频繁输入测试
-- ===========================
vim.keymap.set("n", "<F6>", function()
  local dir = vim.fn.expand("%:p:h")
  local name = vim.fn.expand("%:t:r")
  local ext = vim.fn.expand("%:e")

  local script
  if ext == "py" then
    local file = vim.fn.expand("%:p")
    script = string.format(
      [[
cd %q
clear
echo '🚀 Running %s'
echo '=============='
exec python3 %q
]],
      dir,
      name,
      file
    )
  else
    -- 默认假设已编译好 ./<name>
    script = string.format(
      [[
cd %q
clear
if [ ! -x %q ]; then
  echo '❌ 可执行文件不存在或不可执行：%q'
  exit 1
fi
echo '🚀 Running:'
echo '=============='
exec %q
]],
      dir,
      "./" .. name,
      "./" .. name,
      "./" .. name
    )
  end

  open_term_and_run(script, { cwd = dir })
end, { desc = "Run only (不重新编译)" })

vim.keymap.set("n", "<F4>", function()
  local file = vim.fn.expand("%:p")
  local dir = vim.fn.expand("%:p:h")
  local name = vim.fn.expand("%:t")
  local ext = vim.fn.expand("%:e")

  if ext ~= "sh" then
    vim.notify("当前文件不是 .sh 脚本：" .. name, vim.log.levels.WARN)
    return
  end

  vim.cmd("w")

  local script = string.format(
    [[
cd %q
clear
echo '🐚 Running shell script: %s'
echo '=============='
if [ ! -f %q ]; then
  echo '❌ 脚本文件不存在：%s'
  exit 1
fi
if [ ! -x %q ]; then
  echo '📝 添加执行权限...'
  chmod +x %q
fi
exec bash %q
  ]],
    dir,
    name,
    file,
    name,
    file,
    file,
    file
  )

  open_term_and_run(script, { cwd = dir })
end, { desc = "Run shell script (.sh)" })

-- ===========================
-- F7：用 input.txt 作为标准输入运行（自动喂数据）
-- ===========================
vim.keymap.set("n", "<F7>", function()
  local dir = vim.fn.expand("%:p:h")
  local name = vim.fn.expand("%:t:r")
  local ext = vim.fn.expand("%:e")
  local file = vim.fn.expand("%:p")

  local script
  if ext == "py" then
    script = string.format(
      [[
cd %q
clear
echo '📥 Using input.txt as stdin'
echo '🚀 Running %s < input.txt'
echo '=============='
if [ ! -f input.txt ]; then
  echo '⚠️  没有找到 input.txt，将创建一个空文件'
  :> input.txt
fi
exec bash -lc 'python3 %q < input.txt'
]],
      dir,
      name,
      file
    )
  else
    script = string.format(
      [[
cd %q
clear
if [ ! -x %q ]; then
  echo '❌ 可执行文件不存在或不可执行：%q'
  exit 1
fi
echo '📥 Using input.txt as stdin'
echo '🚀 Running %s < input.txt'
echo '=============='
if [ ! -f input.txt ]; then
  echo '⚠️  没有找到 input.txt，将创建一个空文件'
  :> input.txt
fi
exec bash -lc %q
]],
      dir,
      "./" .. name,
      "./" .. name,
      name,
      string.format("%q < input.txt", "./" .. name)
    )
  end

  open_term_and_run(script, { cwd = dir })
end, { desc = "Run with input.txt (重定向输入)" })

-- ===========================
-- DAP（保留你的功能键位）
-- ===========================
local ok_dap, dap = pcall(require, "dap")
if ok_dap then
  vim.keymap.set("n", "<F9>", dap.continue, { desc = "Start/Continue Debugging" })
  vim.keymap.set("n", "<F8>", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
  vim.keymap.set("n", "<S-F9>", function()
    dap.set_breakpoint(vim.fn.input("Condition: "))
  end, { desc = "Conditional Breakpoint" })
  vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
  vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
  vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })

  vim.keymap.set("n", "<leader>du", function()
    require("dapui").toggle()
  end, { desc = "Toggle DAP UI" })
  vim.keymap.set("n", "<leader>dq", function()
    require("dap").terminate()
    require("dapui").close()
    vim.cmd("echo '🛑 Debugging session terminated'")
  end, { desc = "Quit Debug Session" })
end
