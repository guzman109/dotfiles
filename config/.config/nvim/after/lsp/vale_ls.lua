return {
	cmd = { "vale-ls" },
	autostart = vim.fn.executable("vale-ls") == 1,
	filetypes = { "markdown", "text", "gitcommit", "asciidoc", "rst" },
	root_markers = { ".vale.ini" },
	init_options = {
		installVale = false,
		syncOnStartup = true,
	},
}
