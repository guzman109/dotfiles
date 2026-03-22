-- ── 50_editor.lua ──────────────────────────────
-- ClaudlosVim: Editor plugins — file explorer, finder, git, navigation, formatting.

vim.pack.add({
  -- File explorer
  'https://github.com/stevearc/oil.nvim',

  -- Finder
  'https://github.com/ibhagwan/fzf-lua',

  -- Git
  'https://github.com/lewis6991/gitsigns.nvim',

  -- Code outline
  'https://github.com/stevearc/aerial.nvim',

  -- Folding
  'https://github.com/kevinhwang91/nvim-ufo',
  'https://github.com/kevinhwang91/promise-async',

  -- File navigation
  { src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' },
  'https://github.com/nvim-lua/plenary.nvim',

  -- Formatting
  'https://github.com/stevearc/conform.nvim',

  -- Treesitter
  'https://github.com/nvim-treesitter/nvim-treesitter',

  -- Markdown rendering
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',

  -- HTTP client
  'https://github.com/mistweaverco/kulala.nvim',

  -- Venv selector
  'https://github.com/linux-cultist/venv-selector.nvim',
})

-- ── Oil ────────────────────────────────────────
require('oil').setup({
  default_file_explorer = true,
  view_options = { show_hidden = true },
  keymaps = {
    ['g?'] = 'actions.show_help',
    ['<CR>'] = 'actions.select',
    ['<C-v>'] = 'actions.select_vsplit',
    ['<C-s>'] = 'actions.select_split',
    ['<C-t>'] = 'actions.select_tab',
    ['-'] = 'actions.parent',
    ['_'] = 'actions.open_cwd',
    ['g.'] = 'actions.toggle_hidden',
    ['q'] = 'actions.close',
  },
})

vim.keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent directory' })
vim.keymap.set('n', '<leader>e', '<cmd>Oil<cr>', { desc = 'File explorer' })
vim.keymap.set('n', '<leader>E', '<cmd>tabnew | Oil<cr>', { desc = 'File explorer (tab)' })

-- ── fzf-lua ────────────────────────────────────
require('fzf-lua').setup({
  'default-title',
  winopts = {
    height = 0.85,
    width = 0.80,
    row = 0.35,
    scrollbar = false,
  },
  files = { cwd_prompt = false },
  grep = {
    rg_opts = '--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
  },
})

vim.keymap.set('n', '<leader><space>', function() require('fzf-lua').files() end, { desc = 'Find files' })
vim.keymap.set('n', 'ff', function() require('fzf-lua').files() end, { desc = 'Find files' })
vim.keymap.set('n', '<leader>/', function() require('fzf-lua').live_grep() end, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', function() require('fzf-lua').buffers() end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fh', function() require('fzf-lua').help_tags() end, { desc = 'Help' })
vim.keymap.set('n', '<leader>fr', function() require('fzf-lua').oldfiles() end, { desc = 'Recent files' })
vim.keymap.set('n', '<leader>fd', function() require('fzf-lua').diagnostics_document() end, { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>fs', function() require('fzf-lua').lsp_document_symbols() end, { desc = 'Symbols' })

-- ── Gitsigns ───────────────────────────────────
require('gitsigns').setup({
  signs = {
    add          = { text = '▎' },
    change       = { text = '▎' },
    delete       = { text = '▁' },
    topdelete    = { text = '▔' },
    changedelete = { text = '▎' },
    untracked    = { text = '▎' },
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end
    map('n', ']h', gs.next_hunk, 'Next hunk')
    map('n', '[h', gs.prev_hunk, 'Prev hunk')
    map('n', '<leader>gs', gs.stage_hunk, 'Stage hunk')
    map('n', '<leader>gr', gs.reset_hunk, 'Reset hunk')
    map('n', '<leader>gS', gs.stage_buffer, 'Stage buffer')
    map('n', '<leader>gu', gs.undo_stage_hunk, 'Undo stage hunk')
    map('n', '<leader>gp', gs.preview_hunk, 'Preview hunk')
    map('n', '<leader>gb', function() gs.blame_line({ full = true }) end, 'Blame line')
    map('n', '<leader>gd', gs.diffthis, 'Diff this')
  end,
})

-- ── Aerial ─────────────────────────────────────
require('aerial').setup({
  backends = { 'lsp', 'treesitter', 'markdown' },
  layout = { min_width = 30, default_direction = 'right' },
  show_guides = true,
  filter_kind = false,
})

vim.keymap.set('n', '<leader>co', '<cmd>AerialToggle<cr>', { desc = 'Code outline' })
vim.keymap.set('n', '{', '<cmd>AerialPrev<cr>', { desc = 'Prev symbol' })
vim.keymap.set('n', '}', '<cmd>AerialNext<cr>', { desc = 'Next symbol' })

-- ── UFO (folding) ──────────────────────────────
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

require('ufo').setup({
  provider_selector = function() return { 'lsp', 'indent' } end,
})

vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
vim.keymap.set('n', 'zK', function()
  local winid = require('ufo').peekFoldedLinesUnderCursor()
  if not winid then vim.lsp.buf.hover() end
end, { desc = 'Peek fold' })

-- ── Harpoon ────────────────────────────────────
local harpoon = require('harpoon')
harpoon:setup({
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
  },
})

local harpoon_extensions = require('harpoon.extensions')
harpoon:extend(harpoon_extensions.builtins.highlight_current_file())

harpoon:extend({
  ADD = function() vim.cmd('redrawtabline') end,
  REMOVE = function() vim.cmd('redrawtabline') end,
  LIST_CHANGE = function() vim.cmd('redrawtabline') end,
  UI_CREATE = function(cx)
    vim.keymap.set('n', '<C-v>', function()
      harpoon.ui:select_menu_item({ vsplit = true })
    end, { buffer = cx.bufnr })
    vim.keymap.set('n', '<C-x>', function()
      harpoon.ui:select_menu_item({ split = true })
    end, { buffer = cx.bufnr })
    vim.keymap.set('n', '<C-t>', function()
      harpoon.ui:select_menu_item({ tabedit = true })
    end, { buffer = cx.bufnr })
  end,
})

vim.keymap.set('n', '<leader>ha', function() harpoon:list():add() end, { desc = 'Harpoon add' })
vim.keymap.set('n', '<leader>hd', function() harpoon:list():remove() end, { desc = 'Harpoon remove current' })
vim.keymap.set('n', '<leader>1', function() harpoon:list():select(1) end, { desc = 'Harpoon 1' })
vim.keymap.set('n', '<leader>2', function() harpoon:list():select(2) end, { desc = 'Harpoon 2' })
vim.keymap.set('n', '<leader>3', function() harpoon:list():select(3) end, { desc = 'Harpoon 3' })
vim.keymap.set('n', '<leader>4', function() harpoon:list():select(4) end, { desc = 'Harpoon 4' })
vim.keymap.set('n', '<C-S-P>', function() harpoon:list():prev() end, { desc = 'Harpoon prev' })
vim.keymap.set('n', '<C-S-N>', function() harpoon:list():next() end, { desc = 'Harpoon next' })

vim.keymap.set('n', '<leader>hh', function()
  local items = harpoon:list().items
  local files = {}
  for _, item in ipairs(items) do
    table.insert(files, item.value)
  end
  require('fzf-lua').fzf_exec(files, {
    prompt = 'Harpoon> ',
    actions = {
      ['default'] = require('fzf-lua.actions').file_edit,
    },
  })
end, { desc = 'Harpoon menu' })

-- ── Conform ────────────────────────────────────
require('conform').setup({
  format_on_save = {
    timeout_ms = 500,
    lsp_format = 'fallback',
  },
  formatters_by_ft = {
    c = { 'clang_format' },
    cpp = { 'clang_format' },
    lua = { 'stylua' },
    python = { 'ruff_format' },
    zig = { 'zigfmt' },
  },
  formatters = {
    clang_format = {
      command = '/opt/homebrew/opt/llvm/bin/clang-format',
    },
  },
})

-- ── Treesitter ─────────────────────────────────
require('nvim-treesitter').setup({
  ensure_installed = {
    'json', 'yaml', 'toml', 'bash', 'vimdoc', 'query',
    'c', 'cpp', 'lua', 'python', 'zig',
    'markdown', 'markdown_inline', 'http',
  },
})

-- ── Render Markdown ────────────────────────────
require('render-markdown').setup({
  file_types = { 'markdown', 'codecompanion' },
})

-- ── Kulala (HTTP) ──────────────────────────────
require('kulala').setup({
  default_view = 'body',
  default_env = 'dev',
})

-- ── Venv Selector ──────────────────────────────
require('venv-selector').setup({
  name = { 'venv', '.venv', 'env', '.env' },
  auto_refresh = true,
})
