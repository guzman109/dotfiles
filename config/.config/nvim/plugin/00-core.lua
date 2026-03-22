-- ── 00-core.lua ────────────────────────────────
-- ClaudlosVim: Options, keymaps, autocmds, diagnostics.
-- Loads first (00 prefix) because everything else depends on these.

-- Options ------------------------------------------------

local opt = vim.opt

-- Line numbers: relative makes it easy to count jumps (5j = 5 lines down)
opt.number = true
opt.relativenumber = true
-- Always show sign column (gutter) so layout doesn't shift when signs appear
opt.signcolumn = 'yes'

-- Tabs as 4 spaces everywhere (lang-*.lua files override per language)
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true   -- spaces, not tab characters
opt.smartindent = true -- auto-indent new lines based on syntax

-- Search: case-insensitive unless you type a capital letter
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true  -- highlight all matches
opt.incsearch = true -- show matches as you type

-- Appearance
opt.termguicolors = true -- 24-bit color
opt.cursorline = true    -- highlight the line your cursor is on
opt.scrolloff = 8        -- always keep 8 lines visible above/below cursor
opt.sidescrolloff = 8    -- same but horizontal
opt.wrap = false         -- long lines don't wrap
opt.showmode = false     -- hide -- INSERT -- (mini.statusline shows mode)
opt.pumheight = 10       -- max items in completion popup

-- New splits open to the right and below (not Neovim's weird defaults)
opt.splitright = true
opt.splitbelow = true

-- Persistent undo: close a file, reopen next week, still undo
opt.undofile = true
opt.swapfile = false -- no .swp files
opt.backup = false   -- no backup files

-- Responsiveness
opt.updatetime = 250                      -- faster CursorHold events (used by gitsigns, etc.)
opt.timeoutlen = 300                      -- ms to wait for mapped sequence to complete

opt.completeopt = 'menu,menuone,noselect' -- completion menu behavior
opt.clipboard = 'unnamedplus'             -- yank/paste uses system clipboard
opt.mouse = 'a'                           -- mouse works in all modes

-- Clean UI: fold icons, hide ~ on empty lines
opt.fillchars = {
  fold = ' ', -- fill fold lines with blank space (not dashes)
  foldopen = '▾', -- small down triangle for open folds
  foldclose = '▸', -- small right triangle for closed folds
  foldsep = ' ', -- blank separator between fold column and text
  eob = ' ', -- hide the ~ tildes on empty lines past end of file
}

-- Keymaps ------------------------------------------------

local map = vim.keymap.set

-- General
map('n', '<leader>w', '<cmd>w<cr>', { desc = 'Save' })
map('n', '<leader>q', '<cmd>q<cr>', { desc = 'Quit' })
map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search' })

-- When lines wrap, j/k move by visual line (not actual line)
-- Only when you don't prefix with a count (3j still jumps 3 real lines)
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Alt+j/k moves the current line or selection up/down
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move line down' })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move line up' })
map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move selection down' })
map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move selection up' })

-- Stay in visual mode after indenting (normally it drops the selection)
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Navigate between splits without the <C-w> prefix
map('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })

-- Tabs
map('n', '<leader>tn', '<cmd>tabnew<cr>', { desc = 'New tab' })
map('n', '<leader>tc', '<cmd>tabclose<cr>', { desc = 'Close tab' })
map('n', '<S-h>', '<cmd>tabprevious<cr>', { desc = 'Previous tab' })
map('n', '<S-l>', '<cmd>tabnext<cr>', { desc = 'Next tab' })

-- Format: wrapped in function so it doesn't error if conform isn't loaded yet
map('n', '<leader>cf', function()
  require('conform').format({ lsp_format = 'fallback' })
end, { desc = 'Format' })

-- Diagnostics: jump between errors/warnings
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev diagnostic' })
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line diagnostics' })

-- LSP keymaps: only exist in buffers where an LSP server is active
-- No gd in a random .txt file — these only appear when LSP attaches
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('ClaudlosLsp', { clear = true }),
  callback = function(event)
    local m = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
    end
    m('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
    m('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
    m('n', 'gr', vim.lsp.buf.references, 'References')
    m('n', 'gi', vim.lsp.buf.implementation, 'Implementation')
    m('n', 'K', vim.lsp.buf.hover, 'Hover')
    m('n', '<leader>cr', vim.lsp.buf.rename, 'Rename')
    m('n', '<leader>ca', vim.lsp.buf.code_action, 'Code action')
    m('n', '<leader>cs', vim.lsp.buf.signature_help, 'Signature help')
    m('i', '<C-s>', vim.lsp.buf.signature_help, 'Signature help')

    -- Toggle inlay hints (type annotations, parameter names, etc.)
    m('n', '<leader>ci', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, 'Toggle inlay hints')

    -- Auto-enable inlay hints when LSP attaches
    vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
  end,
})

-- Double-escape exits terminal mode back to normal mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Autocommands --------------------------------------------

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Native treesitter highlighting for every filetype
-- pcall silently ignores filetypes that don't have a parser installed
autocmd('FileType', {
  group = augroup('ClaudlosTreesitter', { clear = true }),
  pattern = '*',
  callback = function() pcall(vim.treesitter.start) end,
})

-- Briefly flash the text you just yanked so you see what got copied
autocmd('TextYankPost', {
  group = augroup('ClaudlosYank', { clear = true }),
  callback = function() vim.hl.on_yank({ timeout = 200 }) end,
})

-- Rebalance split sizes when you resize the terminal window
autocmd('VimResized', {
  group = augroup('ClaudlosResize', { clear = true }),
  command = 'tabdo wincmd =',
})

-- Clean up trailing whitespace on save, restore cursor so you don't jump
autocmd('BufWritePre', {
  group = augroup('ClaudlosWhitespace', { clear = true }),
  pattern = '*',
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

-- Reopen files where you left off last time
autocmd('BufReadPost', {
  group = augroup('ClaudlosLastPos', { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Press q to close help, man pages, quickfix — instead of :q
autocmd('FileType', {
  group = augroup('ClaudlosQuickClose', { clear = true }),
  pattern = { 'help', 'man', 'qf', 'checkhealth', 'dap-float' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

-- Diagnostics ---------------------------------------------

vim.diagnostic.config({
  -- Short inline markers at end of lines with errors/warnings
  virtual_text = {
    spacing = 4,
    prefix = '●',
  },
  -- Full diagnostic text only on the line your cursor is on (nightly feature)
  virtual_lines = {
    current_line = true,
  },
  -- Nerd Font icons in the gutter per severity level
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = vim.fn.nr2char(0xea87) .. ' ',  -- nf-cod-error
      [vim.diagnostic.severity.WARN]  = vim.fn.nr2char(0xea6c) .. ' ',  -- nf-cod-warning
      [vim.diagnostic.severity.HINT]  = vim.fn.nr2char(0xf0335) .. ' ', -- nf-md-lightbulb
      [vim.diagnostic.severity.INFO]  = vim.fn.nr2char(0xea74) .. ' ',  -- nf-cod-info
    },
  },
  underline = true,         -- underline the problematic code
  update_in_insert = false, -- don't flash diagnostics while you're typing
  severity_sort = true,     -- errors show above warnings in sign column
  float = {
    border = 'rounded',     -- rounded border on diagnostic float window
    source = true,          -- show which LSP/linter produced the diagnostic
  },
})
