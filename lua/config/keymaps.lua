-- ============================================================
-- 基础设置
-- ============================================================
vim.g.mapleader = " "
vim.g.maplocalleader = ","

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
-- Run Panel：全局唯一 buffer + window
-- ============================================================
local run_buf
local run_win

local function show_output(lines)
  -- buffer：只创建一次
  if not run_buf or not vim.api.nvim_buf_is_valid(run_buf) then
    run_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(run_buf, "[Run]")
    vim.bo[run_buf].buftype = "nofile"
    vim.bo[run_buf].swapfile = false
    vim.bo[run_buf].modifiable = true
  end

  -- 写内容
  vim.bo[run_buf].modifiable = true
  vim.api.nvim_buf_set_lines(run_buf, 0, -1, false, lines)
  vim.bo[run_buf].modifiable = false

  -- window：存在就复用
  if run_win and vim.api.nvim_win_is_valid(run_win) then
    vim.api.nvim_win_set_buf(run_win, run_buf)
    return
  end

  -- 否则只 split 一次
  vim.cmd("botright split")
  vim.cmd("resize 15")
  run_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(run_win, run_buf)
end

-- ============================================================
-- 核心：用 nvim 0.11 的 vim.system 跑程序（无 terminal）
-- ============================================================
local function run_system(cmd, cwd)
  show_output({ "[Run]", "" })

  vim.system(cmd, { cwd = cwd, text = true }, function(res)
    local out = {}

    if res.stdout and res.stdout ~= "" then
      vim.list_extend(out, vim.split(res.stdout, "\n", { trimempty = true }))
    end

    if res.stderr and res.stderr ~= "" then
      table.insert(out, "")
      table.insert(out, "[stderr]")
      vim.list_extend(out, vim.split(res.stderr, "\n", { trimempty = true }))
    end

    table.insert(out, "")
    table.insert(out, "[Process exited " .. res.code .. "]")

    vim.schedule(function()
      show_output(out)
    end)
  end)
end

-- ============================================================
-- F5：C / C++ / Python 编译 + 运行
-- ============================================================
vim.keymap.set("n", "<F5>", function()
  local file = vim.fn.expand("%:p")
  local dir = vim.fn.expand("%:p:h")
  local ext = vim.fn.expand("%:e")

  vim.cmd("w")

  if ext == "cpp" then
    run_system({ "bash", "-lc", "g++ -std=c++20 -O0 -g *.cpp -o main && ./main" }, dir)
  elseif ext == "c" then
    run_system({ "bash", "-lc", string.format("gcc -std=c11 -O0 -g %q -o main && ./main", file) }, dir)
  elseif ext == "py" then
    run_system({ "python3", file }, dir)
  else
    vim.notify("不支持的文件类型: " .. ext, vim.log.levels.ERROR)
  end
end, { desc = "Build & Run (vim.system)" })

-- ============================================================
-- F6：仅运行（假设已有 ./main）
-- ============================================================
vim.keymap.set("n", "<F6>", function()
  local dir = vim.fn.expand("%:p:h")
  run_system({ "bash", "-lc", "[ -x ./main ] && ./main || echo 'No executable ./main'" }, dir)
end, { desc = "Run only" })

-- ============================================================
-- F7：input.txt 重定向
-- ============================================================
vim.keymap.set("n", "<F7>", function()
  local dir = vim.fn.expand("%:p:h")
  run_system({ "bash", "-lc", "[ -f input.txt ] || touch input.txt; ./main < input.txt" }, dir)
end, { desc = "Run < input.txt" })

-- ============================================================
-- DAP（保持你原来的功能）
-- ============================================================
local ok_dap, dap = pcall(require, "dap")
if ok_dap then
  vim.keymap.set("n", "<F9>", dap.continue, { desc = "Debug Continue" })
  vim.keymap.set("n", "<F8>", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
  vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
  vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
  vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })
end
