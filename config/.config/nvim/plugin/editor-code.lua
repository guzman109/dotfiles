-- ── editor-code.lua ────────────────────────────
-- ClaudlosVim: Code navigation and outline.

vim.pack.add({ 'https://github.com/stevearc/aerial.nvim' })

require('aerial').setup({
  backends = { 'lsp', 'treesitter', 'markdown' },
  layout = {
    min_width = 30,
    default_direction = 'right',
  },
  show_guides = true,
  filter_kind = false,
})

vim.keymap.set('n', '<leader>co', '<cmd>AerialToggle<cr>', { desc = 'Code outline' })
vim.keymap.set('n', '{', '<cmd>AerialPrev<cr>', { desc = 'Prev symbol' })
vim.keymap.set('n', '}', '<cmd>AerialNext<cr>', { desc = 'Next symbol' })
