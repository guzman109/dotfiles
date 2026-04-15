-- ── 60_lsp.lua ─────────────────────────────────
-- Neovim config: LSP configuration and enabling.

vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig", name = "nvim-lspconfig" },
})

vim.lsp.enable({
	"biome",
	"clangd",
	"cssls",
	"emmylua",
	"fish_lsp",
	"harper_ls",
	"just",
	"pyrefly",
	"ruff",
	"sourcekit",
	"superhtml",
	"tailwindcss",
	"vtsls",
	"zls",
})
