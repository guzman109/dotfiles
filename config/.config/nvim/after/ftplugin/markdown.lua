vim.opt_local.wrap = true
vim.diagnostic.config({ update_in_insert = true }, vim.api.nvim_get_current_buf())
vim.opt_local.linebreak = true
vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"
vim.opt_local.conceallevel = 2

vim.lsp.enable("marksman")

vim.keymap.set("n", "j", "gj", { buffer = true })
vim.keymap.set("n", "k", "gk", { buffer = true })
