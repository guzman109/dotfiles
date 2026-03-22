-- ── lang-zig.lua ───────────────────────────────
-- ClaudlosVim: Everything Zig in one place.
-- LSP: zls (managed by zvm)
-- Format: zigfmt (built into zig)
-- DAP: codelldb (installed via Mason)

-- ── LSP ────────────────────────────────────────
vim.lsp.config('zls', {
  cmd = { '/Users/guzman.109/.zvm/bin/zls' },
})
vim.lsp.enable({ 'zls' })

-- ── Formatter ──────────────────────────────────
require('conform').formatters_by_ft.zig = { 'zigfmt' }

-- ── Treesitter ─────────────────────────────────
require('nvim-treesitter').setup({
  ensure_installed = { 'zig' },
})

-- ── DAP ────────────────────────────────────────
-- Zig compiles to native, reuses codelldb from lang-cpp.lua
-- lang-cpp loads first alphabetically, so the adapter exists already
local dap = require('dap')

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

-- ── FileType Settings ──────────────────────────
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('ClaudlosZig', { clear = true }),
  pattern = 'zig',
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true

    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = true, desc = desc })
    end

    map('<leader>zb', function() vim.cmd('!zig build') end, 'Zig build')
    map('<leader>zt', function() vim.cmd('!zig build test') end, 'Zig test')
    map('<leader>zr', function() vim.cmd('!zig run %') end, 'Zig run file')
  end,
})
