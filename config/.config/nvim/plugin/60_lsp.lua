-- ── 60_lsp.lua ─────────────────────────────────
-- Neovim config: LSP configuration and enabling.

vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig", name = "nvim-lspconfig" },
})

vim.lsp.enable({
	"biome",
	"clangd",
	"cssls",
	"docker_language_server",
	"emmylua",
	"fish_lsp",
	"harper_ls",
	"just",
	"mesonlsp",
	"pyrefly",
	"ruff",
	"sourcekit",
	"superhtml",
	"tailwindcss",
	"vale_ls",
	"vtsls",
	"zls",
})
