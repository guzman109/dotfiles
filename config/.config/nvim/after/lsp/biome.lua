local util = require("lspconfig.util")

local biome_config_files = { "biome.json", "biome.jsonc" }
local root_markers = {
	"package-lock.json",
	"yarn.lock",
	"pnpm-lock.yaml",
	"bun.lockb",
	"bun.lock",
	"deno.lock",
}

return {
	workspace_required = false,
	root_dir = function(bufnr, on_dir)
		local filename = vim.api.nvim_buf_get_name(bufnr)
		local project_root = vim.fs.root(bufnr, { root_markers, biome_config_files, { ".git" } }) or vim.fn.getcwd()

		if vim.tbl_contains({ "json", "jsonc" }, vim.bo[bufnr].filetype) then
			on_dir(project_root)
			return
		end

		local config_files = util.insert_package_json(vim.deepcopy(biome_config_files), "biomejs", filename)
		local is_buffer_using_biome = vim.fs.find(config_files, {
			path = filename,
			type = "file",
			limit = 1,
			upward = true,
			stop = vim.fs.dirname(project_root),
		})[1]

		if is_buffer_using_biome then
			on_dir(project_root)
		end
	end,
}
