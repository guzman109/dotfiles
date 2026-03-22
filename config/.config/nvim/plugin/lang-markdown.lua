-- ── lang-markdown.lua ──────────────────────────
-- ClaudlosVim: Markdown rendering + writing settings.

vim.pack.add({ 'https://github.com/MeanderingProgrammer/render-markdown.nvim' })

require('render-markdown').setup({
  file_types = { 'markdown', 'codecompanion' },
})

-- ── Treesitter ─────────────────────────────────
require('nvim-treesitter').setup({
  ensure_installed = { 'markdown', 'markdown_inline' },
})

-- ── FileType Settings ──────────────────────────
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('ClaudlosMarkdown', { clear = true }),
  pattern = 'markdown',
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'en_us'
    vim.opt_local.conceallevel = 2

    vim.keymap.set('n', 'j', 'gj', { buffer = true })
    vim.keymap.set('n', 'k', 'gk', { buffer = true })
  end,
})
