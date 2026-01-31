-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_mini_snippets_in_completion = true
vim.g.root_spec = { "cwd" }
vim.g.autoformat = false
vim.g.lazyvim_python_lsp = "pyrefly"
vim.g.lazyvim_python_ruff = "ruff"

-- System theme switching is handled by system-theme.nvim plugin in lua/plugins/theme.lua

-- Readability improvements
vim.opt.relativenumber = true -- Relative line numbers for easier jumping
vim.opt.cursorline = true -- Highlight current line
vim.opt.number = true -- Show absolute line number on cursor line

-- Whitespace visibility
vim.opt.list = true
vim.opt.listchars = {
  tab = "→ ",
  trail = "·",
  nbsp = "␣",
  extends = "⟩",
  precedes = "⟨",
}

-- Visual guide at line length
vim.opt.colorcolumn = "100"

-- Better split and popup visibility
vim.opt.winblend = 0 -- No transparency in floating windows
vim.opt.pumblend = 0 -- No transparency in popup menus
