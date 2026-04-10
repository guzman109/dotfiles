-- ── 60_lsp.lua ─────────────────────────────────
-- Neovim config: LSP configuration and enabling.

vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
})

vim.lsp.enable({
	"biome",
	"clangd",
	"cssls",
	"emmylua",
	"fish_lsp",
	"just",
	"pyrefly",
	"ruff",
	"superhtml",
	"tailwindcss",
	"vtsls",
	"zls",
})
