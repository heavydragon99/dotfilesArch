return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    local util = require("dap.utils")

    -- Setup DAP UI
    dapui.setup({
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 0.3 },
            { id = "terminal", size = 0.7 },
          },
          size = 15,
          position = "bottom",
        },
      },
    })
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    -- GDB adapter
    dap.adapters.gdb = {
      type = "executable",
      command = "gdb",
      args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
    }

    -- Helper to save/load executable history
    local cache_file = vim.fn.stdpath("cache") .. "/dap_executables.txt"
    local max_history = 10 -- max number of executables to remember

    local function load_history()
      local f = io.open(cache_file, "r")
      if not f then
        return {}
      end
      local history = {}
      for line in f:lines() do
        if vim.fn.filereadable(line) == 1 then
          table.insert(history, line)
        end
      end
      f:close()
      return history
    end

    local function save_history(history)
      local f = io.open(cache_file, "w")
      if f then
        for i = 1, math.min(#history, max_history) do
          f:write(history[i] .. "\n")
        end
        f:close()
      end
    end

    local function pick_executable()
      local history = load_history()

      -- Prompt the user, with last used as default
      local default = history[1] or vim.fn.getcwd() .. "/"
      local path = vim.fn.input("Path to executable: ", default, "file")

      -- Remove duplicates, keep most recent first
      local new_history = { path }
      for _, p in ipairs(history) do
        if p ~= path then
          table.insert(new_history, p)
        end
      end

      save_history(new_history)
      return path
    end

    -- DAP configurations
    dap.configurations.c = {
      {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = pick_executable,
        args = {},
        cwd = "${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false,
        runInTerminal = true,
      },
      {
        name = "Select and attach to process",
        type = "gdb",
        request = "attach",
        program = pick_executable,
        pid = function()
          local name = vim.fn.input("Executable name (filter): ")
          return util.pick_process({ filter = name })
        end,
        cwd = "${workspaceFolder}",
      },
      {
        name = "Attach to gdbserver :1234",
        type = "gdb",
        request = "attach",
        target = "localhost:1234",
        program = pick_executable,
        cwd = "${workspaceFolder}",
      },
    }

    dap.configurations.cpp = dap.configurations.c

    -- Keymaps
    vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP: Continue" })
    vim.keymap.set("n", "<S-F5>", dap.terminate, { desc = "DAP: Stop" })
    vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP: Step Over" })
    vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP: Step Into" })
    vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP: Step Out" })
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>dB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "DAP: Set Conditional Breakpoint" })
  end,
}
