-- ╔═══════════════════════════════════════════════╗
-- ║                  AgentVim                     ║
-- ║ Agentic editing. Native speed. Project tasks. ║
-- ╚═══════════════════════════════════════════════╝

-- Cache bytecode for faster startup (~30% improvement)
vim.loader.enable()

-- Leader must be set before any keymaps (plugin/ files set keymaps)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Rainbow delimiters — must be set BEFORE plugin loads
vim.g.rainbow_delimiters = {
	strategy = {
		[""] = "rainbow-delimiters.strategy.global",
	},
	whitelist = {
		"lua",
		"python",
		"cpp",
		"c",
		"meson",
		"zig",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"html",
		"css",
		"fish",
	},
}

-- Disable netrw (oil.nvim replaces it)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ── PackChanged Hooks ──────────────────────────
-- Must be before any vim.pack.add() call
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind

		-- Update treesitter parsers on plugin update
		if name == "nvim-treesitter" and kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

-- Everything else lives in plugin/ and is auto-discovered by Neovim.
-- Files run in alphabetical order:
--   00-core.lua    → options, keymaps, autocmds, diagnostics
--   01-mini.lua    → mini.nvim modules
--   02-ui.lua      → colorscheme, rainbow-delimiters
--   editor-*.lua   → language-agnostic plugins
--   lang-*.lua     → one file per language (LSP + format + DAP + keymaps)
