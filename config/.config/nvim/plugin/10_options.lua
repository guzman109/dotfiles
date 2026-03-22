-- ── 10_options.lua ─────────────────────────────
-- ClaudlosVim: Built-in Neovim behavior.

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'

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

-- Responsiveness
opt.updatetime = 250
opt.timeoutlen = 300

-- Misc
opt.completeopt = 'menu,menuone,noselect'
opt.clipboard = 'unnamedplus'
opt.mouse = 'a'
opt.laststatus = 3

-- Fold icons, hide ~ on empty lines
opt.fillchars = {
  fold = ' ',
  foldopen = '▾',
  foldclose = '▸',
  foldsep = ' ',
  eob = ' ',
}

-- ── Diagnostics ────────────────────────────────
vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    prefix = '●',
  },
  virtual_lines = {
    current_line = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = vim.fn.nr2char(0xea87) .. ' ',
      [vim.diagnostic.severity.WARN]  = vim.fn.nr2char(0xea6c) .. ' ',
      [vim.diagnostic.severity.HINT]  = vim.fn.nr2char(0xf0335) .. ' ',
      [vim.diagnostic.severity.INFO]  = vim.fn.nr2char(0xea74) .. ' ',
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = true,
  },
})
