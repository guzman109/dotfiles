-- ── 60_lsp.lua ─────────────────────────────────
-- ClaudlosVim: LSP configuration and enabling.

vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })

vim.lsp.enable({ "biome", "clangd", "emmylua", "pyrefly", "ruff", "vtsls", "zls" })
