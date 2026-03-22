-- ── editor-finder.lua ──────────────────────────
-- ClaudlosVim: fzf-lua — fast fuzzy finding.

vim.pack.add({ 'https://github.com/ibhagwan/fzf-lua' })

require('fzf-lua').setup({
  'default-title',
  winopts = {
    height = 0.85,
    width = 0.80,
    row = 0.35,
    preview = {
      layout = 'flex',
      flip_columns = 120,
    },
    scrollbar = false,
  },
  files = { cwd_prompt = false },
  grep = {
    rg_opts = '--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
  },
})

local map = vim.keymap.set
map('n', '<leader><space>', function() require('fzf-lua').files() end, { desc = 'Find files' })
map('n', '<leader>/', function() require('fzf-lua').live_grep() end, { desc = 'Live grep' })
map('n', '<leader>fb', function() require('fzf-lua').buffers() end, { desc = 'Buffers' })
map('n', '<leader>fh', function() require('fzf-lua').help_tags() end, { desc = 'Help' })
map('n', '<leader>fr', function() require('fzf-lua').oldfiles() end, { desc = 'Recent files' })
map('n', '<leader>fd', function() require('fzf-lua').diagnostics_document() end, { desc = 'Diagnostics' })
map('n', '<leader>fs', function() require('fzf-lua').lsp_document_symbols() end, { desc = 'Symbols' })
map('n', 'ff', function() require('fzf-lua').files() end, { desc = 'Find files' })
