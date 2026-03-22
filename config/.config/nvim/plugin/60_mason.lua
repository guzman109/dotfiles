-- ── 60_mason.lua ───────────────────────────
-- ClaudlosVim: Mason — install LSP servers, formatters, and DAP adapters.

vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/williamboman/mason-lspconfig.nvim',
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/jay-babu/mason-nvim-dap.nvim',
})

require('mason').setup()

require('mason-lspconfig').setup({
  ensure_installed = {
    'lua_ls',
    'pyrefly',
    'ruff',
  },
})

require('mason-nvim-dap').setup({
  ensure_installed = {
    'debugpy',
    'codelldb',
  },
})
