vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true
vim.opt_local.commentstring = "// %s"

vim.keymap.set("n", "<leader>cl", "<cmd>ClassLayoutHere<cr>", {
	buffer = true,
	desc = "Show class memory layout",
})
