-- ── 10_options.lua ─────────────────────────────
-- ClaudlosVim: Built-in Neovim behavior.

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"

-- Tabs / indent
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.showmode = false
opt.pumheight = 10

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Persistence
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.shada = "!,'100,<50,s10,h"

-- Responsiveness
opt.updatetime = 250
opt.timeoutlen = 300

-- Navigation
opt.jumpoptions = "stack"

-- Misc
opt.completeopt = "menu,menuone,noselect"
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.laststatus = 3

-- Fold icons, hide ~ on empty lines
opt.fillchars = {
	fold = " ",
	foldopen = "▾",
	foldclose = "▸",
	foldsep = " ",
	eob = " ",
}

-- ── Diagnostics ────────────────────────────────
vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = false,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "●",
			[vim.diagnostic.severity.WARN] = "●",
			[vim.diagnostic.severity.HINT] = "●",
			[vim.diagnostic.severity.INFO] = "●",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
})

-- Pack diagnostic dots together at end of line
local ns = vim.api.nvim_create_namespace("diagnostic_dots")
local severity_hl = {
	[vim.diagnostic.severity.ERROR] = "DiagnosticError",
	[vim.diagnostic.severity.WARN] = "DiagnosticWarn",
	[vim.diagnostic.severity.HINT] = "DiagnosticHint",
	[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
}

vim.diagnostic.handlers["dots"] = {
	show = function(_, bufnr, diagnostics, _)
		vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
		local lines = {}
		for _, d in ipairs(diagnostics) do
			lines[d.lnum] = lines[d.lnum] or {}
			table.insert(lines[d.lnum], d.severity)
		end
		for lnum, sevs in pairs(lines) do
			table.sort(sevs)
			local virt = {}
			for _, s in ipairs(sevs) do
				table.insert(virt, { "●", severity_hl[s] })
			end
			vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, 0, {
				virt_text = virt,
				virt_text_pos = "eol",
			})
		end
	end,
	hide = function(_, bufnr)
		vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
	end,
}

-- Mason Ignores
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
