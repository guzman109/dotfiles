-- ── 60_lsp.lua ─────────────────────────────────
-- Neovim config: LSP configuration and enabling.

vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig", name = "nvim-lspconfig" },
})

local servers = {
	"biome",
	"clangd",
	"cssls",
	"emmylua",
	"fish_lsp",
	"harper_ls",
	"just",
	"neocmake",
	"pyrefly",
	"ruff",
	"superhtml",
	"tailwindcss",
	"vale_ls",
	"vtsls",
}

if vim.fn.executable("docker-language-server") == 1 then
	table.insert(servers, "docker_language_server")
end

if vim.fn.executable("zls") == 1 then
	table.insert(servers, "zls")
end

vim.lsp.enable(servers)
