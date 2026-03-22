-- ── lang-cpp.lua ───────────────────────────────
-- ClaudlosVim: Everything C/C++ in one place.
-- LSP: clangd (brew install llvm)
-- Format: clang-format (brew install llvm)
-- DAP: lldb-dap (brew install llvm)

local llvm_bin = '/opt/homebrew/opt/llvm/bin'

-- ── LSP ────────────────────────────────────────
vim.lsp.config('clangd', {
  cmd = { llvm_bin .. '/clangd' },
})
vim.lsp.enable({ 'clangd' })

-- ── Formatter ──────────────────────────────────
require('conform').formatters_by_ft.c = { 'clang_format' }
require('conform').formatters_by_ft.cpp = { 'clang_format' }
require('conform').formatters.clang_format = {
  command = llvm_bin .. '/clang-format',
}

-- ── Treesitter ─────────────────────────────────
require('nvim-treesitter').setup({
  ensure_installed = { 'c', 'cpp' },
})

-- ── DAP ────────────────────────────────────────
local dap = require('dap')

dap.adapters.codelldb = {
  type = 'server',
  port = '${port}',
  executable = {
    command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
    args = { '--port', '${port}' },
  },
}

dap.configurations.c = {
  {
    name = 'Launch',
    type = 'codelldb', -- changed from lldb
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}
dap.configurations.cpp = dap.configurations.c

-- ── FileType Settings ──────────────────────────
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('ClaudlosCpp', { clear = true }),
  pattern = { 'c', 'cpp' },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
    vim.opt_local.commentstring = '// %s'

    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = true, desc = desc })
    end

    map('<leader>ch', '<cmd>ClangdSwitchSourceHeader<cr>', 'Switch header/source')
    map('<leader>cb', function()
      if vim.fn.filereadable('CMakeLists.txt') == 1 then
        vim.cmd('!cmake --build build')
      elseif vim.fn.filereadable('Makefile') == 1 then
        vim.cmd('!make')
      elseif vim.fn.filereadable('meson.build') == 1 then
        vim.cmd('!meson compile -C build')
      else
        vim.notify('No build system found', vim.log.levels.WARN)
      end
    end, 'Build project')
  end,
})
