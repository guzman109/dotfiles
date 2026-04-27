-- ── 10_options.lua ─────────────────────────────
-- Neovim config: Built-in Neovim behavior.

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
opt.smartindent = false

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
opt.cmdheight = 0
opt.wildoptions = "pum,fuzzy"
opt.wildmode = "full"

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
opt.timeoutlen = 700

-- Navigation
opt.jumpoptions = "stack"

-- Misc
opt.completeopt = "menu,menuone,noselect"
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.laststatus = 3
opt.autoread = true
opt.exrc = true
opt.secure = true

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
			[vim.diagnostic.severity.ERROR] = "󰅚",
			[vim.diagnostic.severity.WARN] = "󰀪",
			[vim.diagnostic.severity.INFO] = "󰋽",
			[vim.diagnostic.severity.HINT] = "󰌶",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
			[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
			[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
			[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
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

-- Mason Ignores
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.filetype.add({
	filename = {
		["compose.yaml"] = "yaml.docker-compose",
		["compose.yml"] = "yaml.docker-compose",
		["docker-compose.yaml"] = "yaml.docker-compose",
		["docker-compose.yml"] = "yaml.docker-compose",
	},
})

-- Auto-refresh buffers when files change outside Neovim.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("NvimConfigAutoRead", { clear = true }),
	callback = function()
		if vim.fn.getcmdwintype() == "" and vim.fn.mode() ~= "c" then
			vim.cmd("silent! checktime")
		end
	end,
})
