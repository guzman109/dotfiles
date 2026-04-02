-- ── 20_keymaps.lua ─────────────────────────────
-- ClaudlosVim: Custom mappings and autocommands.

local map = vim.keymap.set

-- ── General ────────────────────────────────────
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search" })

map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

map("v", "<", "<gv")
map("v", ">", ">gv")

-- ── Navigation ─────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- ── Tabs ───────────────────────────────────────
map("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close other tabs" })
map("n", "<leader>tr", function()
	local current = vim.fn.tabpagenr()
	local last = vim.fn.tabpagenr("$")
	for i = last, current + 1, -1 do
		vim.cmd("tabclose " .. i)
	end
end, { desc = "Close tabs to right" })
map("n", "<S-h>", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
map("n", "<S-l>", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader>t<", "<cmd>tabmove -1<cr>", { desc = "Move tab left" })
map("n", "<leader>t>", "<cmd>tabmove +1<cr>", { desc = "Move tab right" })
-- ── Windows / Splits ───────────────────────────
map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Split vertical" })
map("n", "<leader>ws", "<cmd>split<cr>", { desc = "Split horizontal" })
map("n", "<leader>wd", "<cmd>close<cr>", { desc = "Close split" })
map("n", "<leader>wo", "<cmd>only<cr>", { desc = "Close other splits" })
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize splits" })
map("n", "<leader>wT", "<C-w>T", { desc = "Split to tab" })

-- ── Terminal ───────────────────────────────────
local term_buf = nil
map("n", "<leader>tt", function()
	if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_get_buf(win) == term_buf then
				vim.api.nvim_win_close(win, true)
				return
			end
		end
		vim.cmd("botright 15split")
		vim.api.nvim_win_set_buf(0, term_buf)
	else
		vim.cmd("botright 15split | terminal")
		term_buf = vim.api.nvim_get_current_buf()
	end
end, { desc = "Toggle terminal" })
map("n", "<leader>tT", "<cmd>tabnew | terminal<cr>", { desc = "Terminal (tab)" })
map("n", "<leader>tv", "<cmd>vsplit | terminal<cr>", { desc = "Terminal (vsplit)" })
map("n", "<leader>ts", "<cmd>split | terminal<cr>", { desc = "Terminal (split)" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ── Code ───────────────────────────────────────
map("n", "<leader>cf", function()
	require("conform").format({ lsp_format = "fallback" })
end, { desc = "Format" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- ── LSP Commands ───────────────────────────────
vim.api.nvim_create_user_command("LspStart", function()
	vim.lsp.enable(vim.tbl_keys(vim.lsp.get_clients()))
	vim.notify("LSP started", vim.log.levels.INFO)
end, { desc = "Start LSP" })

vim.api.nvim_create_user_command("LspStop", function()
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		client.stop()
		vim.notify("Stopped " .. client.name, vim.log.levels.INFO)
	end
end, { desc = "Stop LSP" })

vim.api.nvim_create_user_command("LspRestart", function()
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		local bufs = vim.lsp.get_buffers_by_client_id(client.id)
		client.stop()
		vim.defer_fn(function()
			for _, buf in ipairs(bufs) do
				vim.lsp.start(client.config, { bufnr = buf })
			end
			vim.notify("Restarted " .. client.name, vim.log.levels.INFO)
		end, 500)
	end
end, { desc = "Restart LSP" })

vim.api.nvim_create_user_command("LspInfo", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		vim.notify("No LSP clients attached", vim.log.levels.WARN)
		return
	end
	for _, client in ipairs(clients) do
		vim.notify(
			string.format("[%s] id=%d root=%s", client.name, client.id, client.root_dir or "none"),
			vim.log.levels.INFO
		)
	end
end, { desc = "LSP info" })

-- ── Finder ─────────────────────────────────────
map("n", "<leader>fk", function()
	vim.cmd("e " .. vim.fn.stdpath("config") .. "/KEYMAPS.md")
end, { desc = "Open keymaps" })
map("n", "<leader>fc", function()
	vim.cmd("e " .. vim.fn.stdpath("config") .. "/COMMANDS.md")
end, { desc = "Open commands" })

-- ── LSP (on attach) ───────────────────────────
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("ClaudlosLsp", { clear = true }),
	callback = function(event)
		local m = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
		end

		m("n", "gd", vim.lsp.buf.definition, "Go to definition")
		m("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
		m("n", "gr", vim.lsp.buf.references, "References")
		m("n", "gi", vim.lsp.buf.implementation, "Implementation")
		m("n", "K", vim.lsp.buf.hover, "Hover")
		m("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
		m("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
		m("n", "<leader>cs", vim.lsp.buf.signature_help, "Signature help")
		m("i", "<C-s>", vim.lsp.buf.signature_help, "Signature help")

		m("n", "<leader>ci", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end, "Toggle inlay hints")

		vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
	end,
})

-- ── Autocommands ───────────────────────────────
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("FileType", {
	group = augroup("ClaudlosTreesitter", { clear = true }),
	pattern = "*",
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

autocmd("TextYankPost", {
	group = augroup("ClaudlosYank", { clear = true }),
	callback = function()
		vim.hl.on_yank({ timeout = 200 })
	end,
})

autocmd("VimResized", {
	group = augroup("ClaudlosResize", { clear = true }),
	command = "tabdo wincmd =",
})

autocmd("BufWritePre", {
	group = augroup("ClaudlosWhitespace", { clear = true }),
	pattern = "*",
	callback = function()
		if not vim.bo.modifiable then
			return
		end
		local pos = vim.api.nvim_win_get_cursor(0)
		vim.cmd([[%s/\s\+$//e]])
		vim.api.nvim_win_set_cursor(0, pos)
	end,
})

autocmd("BufReadPost", {
	group = augroup("ClaudlosLastPos", { clear = true }),
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local line_count = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= line_count then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

autocmd("FileType", {
	group = augroup("ClaudlosQuickClose", { clear = true }),
	pattern = { "help", "man", "qf", "checkhealth", "dap-float" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- Clear jumplist on startup so C-o/C-i only navigate within this session
autocmd("VimEnter", {
	group = augroup("ClaudlosCleanJumps", { clear = true }),
	callback = function()
		vim.cmd("clearjumps")
	end,
})
