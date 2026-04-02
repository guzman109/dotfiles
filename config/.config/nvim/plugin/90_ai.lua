-- ── 90_ai.lua ──────────────────────────────────
-- ClaudlosVim: Claude Code CLI + diff preview.

-- Autoread so buffers reload after Claude writes
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	group = vim.api.nvim_create_augroup("ClaudlosAutoread", { clear = true }),
	command = "checktime",
})

-- ── Keymaps ────────────────────────────────────
local claude_chan = nil

local function ensure_claude()
	if claude_chan and pcall(vim.fn.chansend, claude_chan, "") then
		return true
	end
	vim.cmd("tabnew | terminal claude")
	claude_chan = vim.bo.channel
	vim.cmd("file Claude")
	return false
end

vim.keymap.set("n", "<leader>ac", function()
	ensure_claude()
end, { desc = "Claude Code" })

vim.keymap.set("n", "<leader>af", function()
	local file = vim.fn.expand("%:p")
	if ensure_claude() then
		vim.fn.chansend(claude_chan, "@" .. file .. " ")
		vim.notify("Added " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
	else
		vim.defer_fn(function()
			vim.fn.chansend(claude_chan, "@" .. file .. " ")
			vim.notify("Added " .. vim.fn.fnamemodify(file, ":t"), vim.log.levels.INFO)
		end, 1000)
	end
end, { desc = "Add file to Claude" })
