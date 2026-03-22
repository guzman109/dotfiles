-- ── lang-lua.lua ───────────────────────────────
-- ClaudlosVim: Everything Lua in one place.
-- LSP: lua_ls (installed via Mason in editor-mason.lua)
-- Format: stylua (brew install stylua)

-- ── LSP ────────────────────────────────────────
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})
vim.lsp.enable({ 'lua_ls' })

-- ── Formatter ──────────────────────────────────
require('conform').formatters_by_ft.lua = { 'stylua' }

-- ── Treesitter ─────────────────────────────────
require('nvim-treesitter').setup({
  ensure_installed = { 'lua' },
})

-- ── FileType Settings ──────────────────────────
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('ClaudlosLua', { clear = true }),
  pattern = 'lua',
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true

    vim.keymap.set('n', '<leader>lx', '<cmd>source %<cr>', { buffer = true, desc = 'Source file' })
  end,
})
