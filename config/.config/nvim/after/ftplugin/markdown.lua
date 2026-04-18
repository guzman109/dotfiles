vim.opt_local.wrap = true
vim.diagnostic.config({ update_in_insert = true }, nil, vim.api.nvim_get_current_buf())
vim.opt_local.linebreak = true
vim.opt_local.conceallevel = 2

vim.lsp.enable("marksman")

vim.keymap.set("n", "j", "gj", { buffer = true })
vim.keymap.set("n", "k", "gk", { buffer = true })

-- Auto-fold mermaid code blocks so only the rendered diagram shows
vim.opt_local.foldmethod = "manual"

local function fold_mermaid_blocks()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for i, line in ipairs(lines) do
		if line:match("^```mermaid") then
			for j = i + 1, #lines do
				if lines[j]:match("^```%s*$") then
					pcall(vim.cmd, i .. "," .. j .. "fold")
					break
				end
			end
		end
	end
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "InsertLeave" }, {
	buffer = 0,
	callback = fold_mermaid_blocks,
})

fold_mermaid_blocks()
