-- ── 60_lsp.lua ─────────────────────────────────
-- ClaudlosVim: LSP configuration and enabling.

vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })

vim.lsp.enable({ 'clangd', 'emmylua', 'pyrefly', 'ruff', 'zls' })
