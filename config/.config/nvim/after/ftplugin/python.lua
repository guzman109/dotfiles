vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = true
vim.opt_local.textwidth = 88

vim.keymap.set('n', '<leader>pv', '<cmd>VenvSelect<cr>', { buffer = true, desc = 'Select venv' })
vim.keymap.set('n', '<leader>pc', '<cmd>VenvSelectCached<cr>', { buffer = true, desc = 'Cached venv' })
vim.keymap.set('n', '<leader>pr', function() vim.cmd('!python3 %') end, { buffer = true, desc = 'Run file' })
vim.keymap.set('n', '<leader>dm', function() require('dap-python').test_method() end, { buffer = true, desc = 'Debug test method' })
vim.keymap.set('n', '<leader>dk', function() require('dap-python').test_class() end, { buffer = true, desc = 'Debug test class' })
