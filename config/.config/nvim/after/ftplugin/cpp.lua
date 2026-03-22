vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true
vim.opt_local.commentstring = '// %s'

vim.keymap.set('n', '<leader>ch', '<cmd>ClangdSwitchSourceHeader<cr>', { buffer = true, desc = 'Switch header/source' })
vim.keymap.set('n', '<leader>cb', function()
  if vim.fn.filereadable('CMakeLists.txt') == 1 then
    vim.cmd('!cmake --build build')
  elseif vim.fn.filereadable('Makefile') == 1 then
    vim.cmd('!make')
  elseif vim.fn.filereadable('meson.build') == 1 then
    vim.cmd('!meson compile -C build')
  else
    vim.notify('No build system found', vim.log.levels.WARN)
  end
end, { buffer = true, desc = 'Build project' })
