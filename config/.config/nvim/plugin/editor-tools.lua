-- ── editor-tools.lua ───────────────────────────
-- ClaudlosVim: oil, ufo, harpoon, conform, treesitter, dap, codecompanion.

vim.pack.add({
  -- File explorer
  'https://github.com/stevearc/oil.nvim',

  -- Folding
  'https://github.com/kevinhwang91/nvim-ufo',
  'https://github.com/kevinhwang91/promise-async',

  -- File navigation
  { src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' },
  'https://github.com/nvim-lua/plenary.nvim',

  -- Formatting (base setup, formatters_by_ft added in lang/ files)
  'https://github.com/stevearc/conform.nvim',

  -- Treesitter (parser management, highlighting is native in 00-core.lua)
  'https://github.com/nvim-treesitter/nvim-treesitter',

  -- Debug (base, adapters configured in lang/ files)
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/mfussenegger/nvim-dap-python',

  -- AI
  'https://github.com/olimorris/codecompanion.nvim',
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

-- ── UFO (folding) ──────────────────────────────
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

require('ufo').setup({
  provider_selector = function()
    return { 'lsp', 'indent' }
  end,
})

vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
vim.keymap.set('n', 'zK', function()
  local winid = require('ufo').peekFoldedLinesUnderCursor()
  if not winid then vim.lsp.buf.hover() end
end, { desc = 'Peek fold' })

-- ── Harpoon ────────────────────────────────────
local harpoon = require('harpoon')
harpoon:setup()

vim.keymap.set('n', '<leader>ha', function() harpoon:list():add() end, { desc = 'Harpoon add' })
vim.keymap.set('n', '<leader>hd', function()
  harpoon:list():remove()
end, { desc = 'Harpoon remove current' })

vim.keymap.set('n', '<leader>1', function() harpoon:list():select(1) end, { desc = 'Harpoon 1' })
vim.keymap.set('n', '<leader>2', function() harpoon:list():select(2) end, { desc = 'Harpoon 2' })
vim.keymap.set('n', '<leader>3', function() harpoon:list():select(3) end, { desc = 'Harpoon 3' })
vim.keymap.set('n', '<leader>4', function() harpoon:list():select(4) end, { desc = 'Harpoon 4' })
vim.keymap.set('n', '<leader>5', function() harpoon:list():select(5) end, { desc = 'Harpoon 5' })
vim.keymap.set('n', '<leader>6', function() harpoon:list():select(6) end, { desc = 'Harpoon 6' })
vim.keymap.set('n', '<leader>7', function() harpoon:list():select(7) end, { desc = 'Harpoon 7' })
vim.keymap.set('n', '<leader>8', function() harpoon:list():select(8) end, { desc = 'Harpoon 8' })
vim.keymap.set('n', '<leader>9', function() harpoon:list():select(9) end, { desc = 'Harpoon 9' })

-- Harpoon menu via fzf-lua (icons + preview + fuzzy)
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

-- ── Conform (base) ─────────────────────────────
-- formatters_by_ft is populated by each lang-*.lua file
require('conform').setup({
  format_on_save = {
    timeout_ms = 500,
    lsp_format = 'fallback',
  },
})

-- ── Treesitter (general parsers) ───────────────
-- Language-specific parsers added in lang-*.lua files
require('nvim-treesitter').setup({
  ensure_installed = {
    'json', 'yaml', 'toml',
    'bash', 'vimdoc', 'query',
  },
})

-- ── DAP (base) ─────────────────────────────────
-- Adapters configured per language in lang-*.lua files
local dap = require('dap')
local dapui = require('dapui')

dapui.setup()

-- Auto open/close DAP UI
dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

-- DAP keymaps
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
vim.keymap.set('n', '<leader>dB', function()
  dap.set_breakpoint(vim.fn.input('Condition: '))
end, { desc = 'Conditional breakpoint' })
vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Continue' })
vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Step into' })
vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Step over' })
vim.keymap.set('n', '<leader>dO', dap.step_out, { desc = 'Step out' })
vim.keymap.set('n', '<leader>dr', dap.restart, { desc = 'Restart' })
vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = 'Terminate' })
vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Toggle DAP UI' })
vim.keymap.set('n', '<leader>de', function() dapui.eval() end, { desc = 'Eval under cursor' })
vim.keymap.set('v', '<leader>de', function() dapui.eval() end, { desc = 'Eval selection' })

-- ── CodeCompanion (AI) ─────────────────────────
require('codecompanion').setup({
  adapters = {
    acp = {
      claude_code = function()
        return require('codecompanion.adapters').extend('claude_code', {
          env = {
            CLAUDE_CODE_OAUTH_TOKEN = vim.env.CLAUDE_CODE_OAUTH_TOKEN,
          },
        })
      end,
      codex = function()
        return require('codecompanion.adapters').extend('codex', {
          defaults = {
            auth_method = 'chatgpt',
          },
        })
      end,
      gemini_cli = function()
        return require('codecompanion.adapters').extend('gemini_cli', {
          defaults = {
            auth_method = 'oauth-personal',
          },
        })
      end,
    },
  },
  interactions = {
    chat = { adapter = 'claude_code' },
    inline = { adapter = 'claude_code' },
    cmd = { adapter = 'claude_code' },
  },
  mcp = {
    servers = {
      ['bear-notes'] = {
        cmd = { 'npx', '-y', 'bear-notes-mcp@latest' },
        enabled = true,
      },
    },
    default_servers = { 'bear-notes' },
  },
})

-- Command abbreviation: cc → CodeCompanion
vim.cmd([[cab cc CodeCompanion]])

-- CodeCompanion keymaps
vim.keymap.set('n', '<C-a>', '<cmd>CodeCompanionActions<cr>', { desc = 'CodeCompanion Actions' })
vim.keymap.set({ 'n', 'v' }, '<LocalLeader>a', '<cmd>CodeCompanionChat Toggle<cr>', { desc = 'Toggle Chat' })
vim.keymap.set('v', 'ga', '<cmd>CodeCompanionChat Add<cr>', { desc = 'Add Selection to Chat' })

vim.keymap.set({ 'n', 'v' }, '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>', { desc = 'Toggle Chat' })
vim.keymap.set('n', '<leader>af', '<cmd>CodeCompanionChat<cr>', { desc = 'Focus Chat' })
vim.keymap.set('n', '<leader>ab', function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.cmd('normal! ggVG')
  vim.cmd("'<,'>CodeCompanionChat Add")
  vim.api.nvim_win_set_cursor(0, cursor)
end, { desc = 'Add Buffer to Chat' })
vim.keymap.set('v', '<leader>as', '<cmd>CodeCompanionChat Add<cr>', { desc = 'Add Selection to Chat' })
vim.keymap.set('n', '<leader>aa', function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('gda', true, false, true), 'm', false)
end, { desc = 'Accept Diff' })
vim.keymap.set('n', '<leader>ad', function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('gdr', true, false, true), 'm', false)
end, { desc = 'Reject Diff' })
