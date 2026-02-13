-- lua/configs/dap.lua

local dap = require "dap"
local dapui = require "dapui"

-- Set up dap-ui (optional but recommended)
dapui.setup()

-- Auto open/close UI when session starts/stops
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Python adapter for local debugging
dap.adapters.python = {
  type = "executable",
  command = "python", -- or path to your Python
  args = { "-m", "debugpy.adapter" },
}

-- Python configurations
dap.configurations.python = {
  -- Launch config (runs Python script directly)
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    console = "integratedTerminal",
  },
  -- Attach config (attach to Python already running debugpy)
  {
    type = "python",
    request = "attach",
    name = "Attach to Debugpy",
    connect = {
      host = "0.0.0.0",
      port = 5678,
    },
    mode = "remote",
    cwd = vim.fn.getcwd(),
  },
}
