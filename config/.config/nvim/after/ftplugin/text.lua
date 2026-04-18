vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.diagnostic.config({ update_in_insert = true }, nil, vim.api.nvim_get_current_buf())
