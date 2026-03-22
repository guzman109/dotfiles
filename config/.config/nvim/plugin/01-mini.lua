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

-- ── Starter (dashboard) ───────────────────────
-- Recreates the Snacks dashboard layout
-- local starter = require('mini.starter')

-- Motivational quote from your fish script (falls back gracefully)
-- local function get_quote()
--   local ok, quote = pcall(vim.fn.system, 'fish ~/.config/inspiration/quote-cache.fish --type motivation --box 58')
--   if ok and vim.v.shell_error == 0 then
--     return quote
--   end
--   return ''
-- end
--
-- -- Date header
-- local date_str = os.date('%A, %B %d, %Y')
--
-- starter.setup({
--   header = table.concat({
--     '',
--     '   ClaudlosVim',
--     '',
--     '   ' .. date_str,
--     '',
--     get_quote(),
--   }, '\n'),
--   items = {
--     -- Keymaps (actions)
--     { name = 'Find files',   action = 'FzfLua files',                                    section = 'Keymaps' },
--     { name = 'Live grep',    action = 'FzfLua live_grep',                                section = 'Keymaps' },
--     { name = 'Recent files', action = 'FzfLua oldfiles',                                 section = 'Keymaps' },
--     { name = 'Edit config',  action = 'e ' .. vim.fn.stdpath('config') .. '/init.lua',   section = 'Keymaps' },
--     { name = 'View keymaps', action = 'e ' .. vim.fn.stdpath('config') .. '/KEYMAPS.md', section = 'Keymaps' },
--
--     -- TODOs
--     {
--       name = 'TODOs',
--       action = function()
--         require('fzf-lua').grep({ search = 'TODO|FIXME|HACK|NOTE|WARN' })
--       end,
--       section = 'Keymaps'
--     },
--
--     -- Recent files (current project)
--     starter.sections.recent_files(5, false, nil, 'Recent Files'),
--
--     -- Projects (recent files global acts as project switcher)
--     starter.sections.recent_files(5, true, nil, 'Projects'),
--   },
--   content_hooks = {
--     starter.gen_hook.adding_bullet(),
--     starter.gen_hook.aligning('center', 'center'),
--   },
--   footer = '',
-- })
--
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
