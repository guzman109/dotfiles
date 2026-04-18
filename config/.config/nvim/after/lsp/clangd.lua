local clangd = vim.fn.executable("/opt/homebrew/opt/llvm/bin/clangd") == 1 and "/opt/homebrew/opt/llvm/bin/clangd"
	or "clangd"

return {
	cmd = {
		clangd,
		"--background-index",
		"--clang-tidy",
		"--completion-style=detailed",
		"--header-insertion=iwyu",
		"--pch-storage=memory",
	},
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	root_markers = {
		".clangd",
		"compile_commands.json",
		"compile_flags.txt",
		"meson.build",
		"conanfile.py",
		"conanfile.txt",
		"CMakeLists.txt",
		".git",
	},
}
