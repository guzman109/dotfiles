-- ── lang-python.lua ────────────────────────────
-- ClaudlosVim: Everything Python in one place.
-- LSP: pyrefly (uv tool install pyrefly)
-- Lint: ruff (uv tool install ruff)
-- Format: ruff_format
-- DAP: debugpy (uv tool install debugpy)

vim.pack.add({ 'https://github.com/linux-cultist/venv-selector.nvim' })

-- ── LSP ────────────────────────────────────────
vim.lsp.config('pyrefly', {})
vim.lsp.config('ruff', {})
vim.lsp.enable({ 'pyrefly', 'ruff' })

-- ── Formatter ──────────────────────────────────
require('conform').formatters_by_ft.python = { 'ruff_format' }

-- ── Treesitter ─────────────────────────────────
require('nvim-treesitter').setup({
  ensure_installed = { 'python' },
})

-- ── Venv Selector ──────────────────────────────
require('venv-selector').setup({
  name = { 'venv', '.venv', 'env', '.env' },
  auto_refresh = true,
})

-- ── DAP ────────────────────────────────────────
local dap_python = require('dap-python')
dap_python.setup(vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python')
dap_python.test_runner = 'pytest'

-- ── FileType Settings ──────────────────────────
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('ClaudlosPython', { clear = true }),
  pattern = 'python',
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
    vim.opt_local.textwidth = 88

    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = true, desc = desc })
    end

    map('<leader>pv', '<cmd>VenvSelect<cr>', 'Select venv')
    map('<leader>pc', '<cmd>VenvSelectCached<cr>', 'Cached venv')
    map('<leader>pr', function() vim.cmd('!python3 %') end, 'Run file')
    map('<leader>dm', function() require('dap-python').test_method() end, 'Debug test method')
    map('<leader>dk', function() require('dap-python').test_class() end, 'Debug test class')
  end,
})
