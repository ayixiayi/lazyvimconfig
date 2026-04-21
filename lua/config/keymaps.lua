-- ============================================================
-- <leader>h：回到首页（Snacks Dashboard，你验证过可用的版本）
-- ============================================================
vim.keymap.set("n", "<leader>h", function()
  local ok, snacks = pcall(require, "snacks")
  if not ok or not snacks.dashboard then
    vim.notify("Snacks dashboard 未加载", vim.log.levels.ERROR)
    return
  end

  -- 如果已经在 dashboard，先退出再重新打开（避免 Snacks 内部炸）
  if vim.bo.filetype == "snacks_dashboard" then
    vim.cmd("bd!")
    vim.schedule(function()
      snacks.dashboard.open()
    end)
  else
    snacks.dashboard.open()
  end
end, { desc = "Home Dashboard (Snacks)" })

-- ============================================================
-- toggleterm: F5 编译+运行 / F6 仅运行 / F7 input.txt 重定向
-- ============================================================
local Terminal = require("toggleterm.terminal").Terminal
local run_term

local function run_in_term(cmd, dir)
  if run_term then
    run_term:shutdown()
  end
  run_term = Terminal:new({
    cmd = "bash -lc " .. vim.fn.shellescape("cd " .. dir .. " && " .. cmd),
    direction = "horizontal",
    size = 15,
    close_on_exit = false,
  })
  run_term:toggle()
end

vim.keymap.set("n", "<F5>", function()
  local file = vim.fn.expand("%:p")
  local dir = vim.fn.expand("%:p:h")
  local ext = vim.fn.expand("%:e")

  vim.cmd("w")

  local cmd
  if ext == "cpp" then
    cmd = "g++ -std=c++20 -O0 -g *.cpp -o main && ./main"
  elseif ext == "c" then
    cmd = string.format("gcc -std=c11 -O0 -g %q -o main && ./main", file)
  elseif ext == "py" then
    cmd = string.format("python3 %q", file)
  else
    vim.notify("不支持的文件类型: " .. ext, vim.log.levels.ERROR)
    return
  end

  run_in_term(cmd, dir)
end, { desc = "Build & Run" })

vim.keymap.set("n", "<F6>", function()
  run_in_term("[ -x ./main ] && ./main || echo 'No executable ./main'", vim.fn.expand("%:p:h"))
end, { desc = "Run only" })

vim.keymap.set("n", "<F7>", function()
  local dir = vim.fn.expand("%:p:h")
  run_in_term("[ -f input.txt ] || touch input.txt; ./main < input.txt", dir)
end, { desc = "Run < input.txt" })

-- ============================================================
-- 窗口操作: <leader>w 恢复为 <C-w> 代理 (LazyVim 默认行为)
-- ============================================================
vim.keymap.set("n", "<leader>w", "<C-w>", { desc = "Windows", remap = true })

-- ============================================================
-- 窗口大小平滑调整 — 进入 resize 模式后用 h/j/k/l 连续调整
-- <leader>wr 进入模式, 按 h/l 调宽度, j/k 调高度, q/Esc 退出
-- 解决 WSL+WezTerm 下 Ctrl+Arrow 不能 key repeat 的问题
-- ============================================================
local resize_mode = false
local resize_step = 3

local function exit_resize_mode()
  if not resize_mode then
    return
  end
  resize_mode = false
  vim.keymap.del("n", "l", { buffer = 0 })
  vim.keymap.del("n", "h", { buffer = 0 })
  vim.keymap.del("n", "k", { buffer = 0 })
  vim.keymap.del("n", "j", { buffer = 0 })
  vim.keymap.del("n", "q", { buffer = 0 })
  vim.keymap.del("n", "<Esc>", { buffer = 0 })
  vim.notify("Resize mode OFF", vim.log.levels.INFO)
end

local function enter_resize_mode()
  if resize_mode then
    exit_resize_mode()
    return
  end
  resize_mode = true
  local opts = { buffer = 0, nowait = true }
  vim.keymap.set("n", "l", function() vim.cmd("vertical resize +" .. resize_step) end, opts)
  vim.keymap.set("n", "h", function() vim.cmd("vertical resize -" .. resize_step) end, opts)
  vim.keymap.set("n", "k", function() vim.cmd("resize +" .. resize_step) end, opts)
  vim.keymap.set("n", "j", function() vim.cmd("resize -" .. resize_step) end, opts)
  vim.keymap.set("n", "q", exit_resize_mode, opts)
  vim.keymap.set("n", "<Esc>", exit_resize_mode, opts)
  vim.notify("Resize mode ON — h/j/k/l to resize, q/Esc to quit", vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>wr", enter_resize_mode, { desc = "Resize Mode (h/j/k/l)" })

-- ============================================================
-- DAP（保持你原来的功能）
-- ============================================================
-- <C-a> 全选（覆盖原生数字递增，用 g<C-a> 仍可递增）
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select All" })

local ok_dap, dap = pcall(require, "dap")
if ok_dap then
  vim.keymap.set("n", "<F9>", dap.continue, { desc = "Debug Continue" })
  vim.keymap.set("n", "<F8>", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
  vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
  vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
  vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })
end

-- ============================================================
-- Neovim 0.12 内置工具
-- ============================================================
vim.keymap.set("n", "<leader>uu", function()
  vim.cmd("packadd nvim.undotree")
  vim.cmd("Undotree")
end, { desc = "Undotree (built-in)" })
