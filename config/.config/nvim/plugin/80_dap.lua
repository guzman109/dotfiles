-- ── 80_dap.lua ─────────────────────────────────
-- Neovim config: Debug Adapter Protocol.

vim.pack.add({
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/mfussenegger/nvim-dap-python',
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/jay-babu/mason-nvim-dap.nvim',
})

require('mason').setup()
require('mason-nvim-dap').setup({
  ensure_installed = { 'codelldb' },
})

local dap = require('dap')
local dapui = require('dapui')

dapui.setup()

-- Auto open/close DAP UI
dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

-- ── Adapters ───────────────────────────────────

-- codelldb (C/C++/Zig — installed via Mason)
dap.adapters.codelldb = {
  type = 'server',
  port = '${port}',
  executable = {
    command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
    args = { '--port', '${port}' },
  },
}

-- debugpy (Python — installed via uv)
local dap_python = require('dap-python')
dap_python.setup('python3')
dap_python.test_runner = 'pytest'

-- ── Configurations ─────────────────────────────

dap.configurations.c = {
  {
    name = 'Launch',
    type = 'codelldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}
dap.configurations.cpp = dap.configurations.c

dap.configurations.zig = {
  {
    name = 'Launch (Zig)',
    type = 'codelldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/zig-out/bin/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}

-- ── Keymaps ────────────────────────────────────
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
vim.keymap.set('n', '<leader>dB', function()
  dap.set_breakpoint(vim.fn.input('Condition: '))
end, { desc = 'Conditional breakpoint' })
vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Continue' })
vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Step into' })
vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Step over' })
vim.keymap.set('n', '<leader>dO', dap.step_out, { desc = 'Step out' })
vim.keymap.set('n', '<leader>dr', dap.restart, { desc = 'Restart' })
vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = 'Terminate' })
vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Toggle DAP UI' })
vim.keymap.set('n', '<leader>de', function() dapui.eval() end, { desc = 'Eval under cursor' })
vim.keymap.set('v', '<leader>de', function() dapui.eval() end, { desc = 'Eval selection' })
