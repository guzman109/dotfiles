-- ── 01-mini.lua ────────────────────────────────
-- ClaudlosVim: mini.nvim modules.
-- Loads early (01 prefix) because other plugins may depend on mini.icons.

vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

-- Surround editing (sa = add, sd = delete, sr = replace)
require('mini.surround').setup()

-- Auto-close brackets and quotes
require('mini.pairs').setup()

-- File icons (used by fzf-lua, oil, etc.)
require('mini.icons').setup({
  extension = {
    hpp = { glyph = '󰫵', hl = 'MiniIconsBlue' },
  },
  file = {
    ['conanfile.py'] = { glyph = '󰆦', hl = 'MiniIconsBlue' },
    ['conanfile.txt'] = { glyph = '󰆦', hl = 'MiniIconsBlue' },
  },
  filetype = {
    meson = { glyph = '󰰐', hl = 'MiniIconsPurple' },
    cpp = { glyph = "", hl = "MiniIconsBlue" }
  },
})

-- ── Clue (keymap hints) ───────────────────────
-- Shows available keymaps in a popup after pressing a leader/prefix key
local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    -- Leader
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },

    -- Built-in
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },
    { mode = 'n', keys = "'" },
    { mode = 'x', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = '`' },
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },

    -- Window
    { mode = 'n', keys = '<C-w>' },

    -- z (folds, spelling, etc.)
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },

    -- Brackets
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },

    -- Theme
    { mode = 'v', keys = '<Leader>a', desc = '+ai' },
  },

  -- Give the popup human-readable group names
  clues = {
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),

    -- Custom group descriptions for <leader> prefixes
    { mode = 'n', keys = '<Leader>f', desc = '+find' },
    { mode = 'n', keys = '<Leader>g', desc = '+git' },
    { mode = 'n', keys = '<Leader>c', desc = '+code' },
    { mode = 'n', keys = '<Leader>d', desc = '+debug' },
    { mode = 'n', keys = '<Leader>t', desc = '+tab' },
    { mode = 'n', keys = '<Leader>p', desc = '+python' },
    { mode = 'n', keys = '<Leader>z', desc = '+zig' },
    { mode = 'n', keys = '<Leader>h', desc = '+harpoon' },
    { mode = 'n', keys = '<Leader>k', desc = '+kulala' },
    { mode = 'n', keys = '<Leader>a', desc = '+ai' },
    { mode = 'n', keys = '<Leader>l', desc = '+lua' },
    { mode = 'n', keys = '<Leader>w', desc = '+window' },

  },

  window = {
    delay = 300, -- ms before popup appears
    config = {
      width = 'auto',
    },
  },
})

-- Animate
require('mini.animate').setup()
