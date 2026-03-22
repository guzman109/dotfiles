-- ── 40_ui.lua ──────────────────────────────────
-- ClaudlosVim: Colorscheme and visual enhancements.
-- Loads early (02 prefix) so colors are set before first draw.

vim.pack.add({
  'https://github.com/catppuccin/nvim',
  'https://github.com/HiPhish/rainbow-delimiters.nvim',
  'https://github.com/f-person/auto-dark-mode.nvim',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/lukas-reineke/indent-blankline.nvim',
  'https://github.com/goolord/alpha-nvim',
  'https://github.com/nanozuki/tabby.nvim',
})

-- ── Catppuccin ─────────────────────────────────
require('catppuccin').setup({
  flavour = 'auto',
  background = {
    light = 'latte',
    dark = 'mocha',
  },
  transparent_background = true,
  show_end_of_buffer = true,
  term_colors = true,
  styles = {
    comments = { 'bold', 'italic' },
    keywords = { 'italic', 'bold' },
    functions = { 'italic' },
    loops = { 'italic' },
    properties = { 'bold' },
    types = { 'italic', 'bold' },
    operators = { 'bold' },
  },
  integrations = {
    aerial = true,
    alpha = true,
    blink_cmp = true,
    dap = true,
    dap_ui = true,
    gitsigns = true,
    harpoon = true,
    indent_blankline = { enabled = true },
    mason = true,
    mini = { enabled = true },
    rainbow_delimiters = true,
    render_markdown = true,
    ufo = true,
    native_lsp = {
      enabled = true,
      underlines = {
        errors = { 'undercurl' },
        hints = { 'undercurl' },
        warnings = { 'undercurl' },
        information = { 'undercurl' },
      },
    },
  },
})

vim.cmd.colorscheme('catppuccin')

-- ── Auto Dark Mode ─────────────────────────────
require('auto-dark-mode').setup({
  update_interval = 1000,
  set_dark_mode = function()
    vim.api.nvim_set_option_value('background', 'dark', {})
    vim.cmd.colorscheme('catppuccin-mocha')
    package.loaded['tabby_cfg'] = nil
    vim.api.nvim_set_hl(0, 'TabLineFill', { bg = 'NONE' })
    require('tabby').setup({ tabline = require('tabby_cfg') })
  end,
  set_light_mode = function()
    vim.api.nvim_set_option_value('background', 'light', {})
    vim.cmd.colorscheme('catppuccin-latte')
    package.loaded['tabby_cfg'] = nil
    vim.api.nvim_set_hl(0, 'TabLineFill', { bg = 'NONE' })
    require('tabby').setup({ tabline = require('tabby_cfg') })
  end,
})

-- ── Lualine ────────────────────────────────────
local function datetime()
  local CTimeLine = require('lualine.component'):extend()
  CTimeLine.init = function(self, options)
    CTimeLine.super.init(self, options)
  end
  CTimeLine.update_status = function(self)
    return os.date(self.options.format or '%a %b %d %I:%M %p', os.time())
  end
  return CTimeLine
end

require('lualine').setup({
  options = {
    theme = 'auto',
    component_separators = '',
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { 'encoding', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = {
      { datetime(), separator = { right = "" }, left_padding = 2 },
    },
  },
})

-- ── Indent Guides ──────────────────────────────
require('ibl').setup({
  indent = {
    char = '│',
    tab_char = '│',
  },
  scope = { enabled = false },
  exclude = {
    filetypes = { 'help', 'alpha', 'mason', 'checkhealth' },
  },
})

-- ── Tabby (tabline) ───────────────────────────
require('tabby').setup({
  tabline = require('tabby_cfg'),
})

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('ClaudlosTabby', { clear = true }),
  callback = function()
    require('tabby').setup({
      tabline = require('tabby_cfg'),
    })
  end,
})
vim.api.nvim_set_hl(0, 'TabLineFill', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'TabLine', { bg = 'NONE' })

-- ── Alpha (dashboard) ─────────────────────────
local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')

-- Quote from your fish script
local function get_quote()
  local ok, quote = pcall(vim.fn.system, 'fish ~/.config/inspiration/quote-cache.fish --type motivation --box 58')
  if ok and vim.v.shell_error == 0 then
    return vim.split(quote, '\n')
  end
  return { '' }
end

-- Header: ASCII title + date + quote
local header_lines = {
  '',
  '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
  '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
  '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
  '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
  '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
  '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
  '',
  '   ' .. os.date('%A, %B %d, %Y'),
  '',
}
vim.list_extend(header_lines, get_quote())
table.insert(header_lines, '')

dashboard.section.header.val = header_lines
dashboard.section.header.opts = { hl = 'DiagnosticOk', position = 'center' }

-- Buttons: close alpha first so fzf-lua gets a real buffer
local function alpha_fzf(fzf_fn, opts)
  return function()
    vim.cmd('enew')
    fzf_fn(opts or {})
  end
end

dashboard.section.buttons.val = {
  dashboard.button('f', '  Find files', '<cmd>FzfLua files<cr>'),
  dashboard.button('g', '  Live grep', '<cmd>FzfLua live_grep<cr>'),
  dashboard.button('r', '  Recent files', '<cmd>FzfLua oldfiles<cr>'), dashboard.button('t', '  TODOs',
  function() alpha_fzf(require('fzf-lua').grep, { search = 'TODO|FIXME|HACK|NOTE|WARN' })() end),
  dashboard.button('c', '  Edit config', '<cmd>e ' .. vim.fn.stdpath('config') .. '/init.lua<cr>'),
  dashboard.button('k', '  Keymaps', '<cmd>e ' .. vim.fn.stdpath('config') .. '/KEYMAPS.md<cr>'),
  dashboard.button('u', '  Update plugins', '<cmd>lua vim.pack.update()<cr>'),
  dashboard.button('x', '  Clean plugins', function()
    local unused = vim.iter(vim.pack.get())
        :filter(function(x) return not x.active end)
        :map(function(x) return x.spec.name end)
        :totable()
    if #unused == 0 then
      vim.notify('No unused plugins to clean', vim.log.levels.INFO)
    else
      vim.notify('Removing: ' .. table.concat(unused, ', '), vim.log.levels.INFO)
      for _, name in ipairs(unused) do
        vim.pack.del({ name }, { force = true })
      end
      vim.notify('Done! Removed ' .. #unused .. ' plugins', vim.log.levels.INFO)
    end
  end),
  dashboard.button('q', '  Quit', '<cmd>qa<cr>'),
}

-- Footer
dashboard.section.footer.val = ''

-- Layout
dashboard.config.layout = {
  { type = 'padding', val = 2 },
  dashboard.section.header,
  { type = 'padding', val = 2 },
  dashboard.section.buttons,
  { type = 'padding', val = 1 },
  dashboard.section.footer,
}

alpha.setup(dashboard.config)

-- Disable folding in alpha buffer
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('ClaudlosAlpha', { clear = true }),
  pattern = 'alpha',
  callback = function()
    vim.opt_local.foldenable = false
  end,
})
