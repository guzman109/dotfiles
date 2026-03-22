-- ── lang-http.lua ──────────────────────────────
-- ClaudlosVim: kulala.nvim for .http files.

vim.pack.add({ 'https://github.com/mistweaverco/kulala.nvim' })

-- ── Treesitter ─────────────────────────────────
require('nvim-treesitter').setup({
  ensure_installed = { 'http' },
})

-- ── Plugin Setup ───────────────────────────────
require('kulala').setup({
  default_view = 'body',
  default_env = 'dev',
})

-- ── FileType Settings ──────────────────────────
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('ClaudlosHttp', { clear = true }),
  pattern = 'http',
  callback = function()
    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = true, desc = desc })
    end

    map('<leader>kr', function() require('kulala').run() end, 'Run request')
    map('<leader>ka', function() require('kulala').run_all() end, 'Run all')
    map('<leader>kn', function() require('kulala').jump_next() end, 'Next request')
    map('<leader>kp', function() require('kulala').jump_prev() end, 'Prev request')
    map('<leader>ke', function() require('kulala').set_selected_env() end, 'Select env')
    map('<leader>kc', function() require('kulala').copy() end, 'Copy as cURL')
  end,
})
