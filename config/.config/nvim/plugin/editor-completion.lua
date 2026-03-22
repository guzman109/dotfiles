-- ── editor-completion.lua ──────────────────────
-- ClaudlosVim: blink.cmp — fast, Rust-based completion.

vim.pack.add({
  -- Pin to release tag so prebuilt Rust fuzzy binary auto-downloads
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('^1') },
})

require('blink.cmp').setup({
  keymap = {
    preset = 'default',
    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-e>'] = { 'hide' },
    ['<CR>'] = { 'accept', 'fallback' },
    ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
    ['<C-n>'] = { 'select_next', 'fallback' },
    ['<C-p>'] = { 'select_prev', 'fallback' },
    ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
    ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
  },
  appearance = {
    use_nvim_cmp_as_default = false,
    nerd_font_variant = 'mono',
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    per_filetype = {
      codecompanion = { 'codecompanion' },
    },
  },
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },
    menu = {
      draw = {
        columns = {
          { 'kind_icon' },
          { 'label',    'label_description', gap = 1 },
        },
      },
    },
  },
  signature = {
    enabled = true,
  },
  -- Pure Lua fuzzy matching (no Rust binary needed)
  fuzzy = {
    implementation = 'lua',
  },
})
