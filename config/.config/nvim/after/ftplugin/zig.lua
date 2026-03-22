vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = true

vim.keymap.set('n', '<leader>zb', function() vim.cmd('!zig build') end, { buffer = true, desc = 'Zig build' })
vim.keymap.set('n', '<leader>zt', function() vim.cmd('!zig build test') end, { buffer = true, desc = 'Zig test' })
vim.keymap.set('n', '<leader>zr', function() vim.cmd('!zig run %') end, { buffer = true, desc = 'Zig run file' })
