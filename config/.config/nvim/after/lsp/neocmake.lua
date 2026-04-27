return {
	cmd = { "neocmakelsp", "stdio" },
	filetypes = { "cmake" },
	root_markers = { "CMakeLists.txt", ".git" },
	single_file_support = true,
	init_options = {
		format = {
			enable = true,
		},
		lint = {
			enable = true,
		},
		scan_cmake_in_package = true,
		semantic_token = false,
	},
}
