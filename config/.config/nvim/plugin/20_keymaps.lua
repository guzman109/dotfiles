-- ── 20_keymaps.lua ─────────────────────────────
-- Neovim config: Custom mappings and autocommands.

local map = vim.keymap.set

-- ── General ────────────────────────────────────
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search" })

map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

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
map("n", "<leader>w+", "<cmd>resize +3<cr>", { desc = "Increase split height" })
map("n", "<leader>w-", "<cmd>resize -3<cr>", { desc = "Decrease split height" })
map("n", "<leader>w>", "<cmd>vertical resize +8<cr>", { desc = "Increase split width" })
map("n", "<leader>w<", "<cmd>vertical resize -8<cr>", { desc = "Decrease split width" })
map("n", "<leader>wH", function()
	local statusline = vim.o.laststatus > 0 and 1 or 0
	local tabline = vim.o.showtabline > 0 and 1 or 0
	local available = math.max(1, vim.o.lines - vim.o.cmdheight - statusline - tabline)
	vim.cmd("resize " .. math.floor(available / 2))
end, { desc = "Set split half height" })
map("n", "<leader>wV", function()
	vim.cmd("vertical resize " .. math.floor(vim.o.columns / 2))
end, { desc = "Set split half width" })

-- ── Terminal ───────────────────────────────────
map("n", "<leader>tt", "<cmd>botright 12split | terminal<cr>", { desc = "Terminal (small split)" })
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
		client:stop()
		vim.notify("Stopped " .. client.name, vim.log.levels.INFO)
	end
end, { desc = "Stop LSP" })

vim.api.nvim_create_user_command("LspRestart", function()
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		local bufs = vim.tbl_keys(client.attached_buffers or {})
		client:stop()
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

-- ── Neovim Config / Core ──────────────────────
local function clean_plugins()
	local unused = vim.iter(vim.pack.get())
		:filter(function(plugin)
			return not plugin.active
		end)
		:map(function(plugin)
			return plugin.spec.name
		end)
		:totable()

	if #unused == 0 then
		vim.notify("No unused plugins to clean", vim.log.levels.INFO)
		return
	end

	vim.notify("Removing: " .. table.concat(unused, ", "), vim.log.levels.INFO)
	for _, name in ipairs(unused) do
		vim.pack.del({ name }, { force = true })
	end
	vim.notify("Done! Removed " .. #unused .. " plugins", vim.log.levels.INFO)
end

map("n", "<leader>Ni", function()
	vim.cmd("e " .. vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "Edit init.lua" })
map("n", "<leader>Nk", function()
	vim.cmd("e " .. vim.fn.stdpath("config") .. "/KEYMAPS.md")
end, { desc = "Open keymaps" })
map("n", "<leader>Nc", function()
	vim.cmd("e " .. vim.fn.stdpath("config") .. "/COMMANDS.md")
end, { desc = "Open commands" })
map("n", "<leader>Nu", function()
	vim.pack.update()
end, { desc = "Update plugins" })
map("n", "<leader>Nx", clean_plugins, { desc = "Clean inactive plugins" })
map("n", "<leader>Nr", "<cmd>restart<cr>", { desc = "Restart Neovim" })
map("n", "<leader>Nq", "<cmd>qa<cr>", { desc = "Quit Neovim" })

-- ── Project Tasks ──────────────────────────────
local function find_justfile()
	local current = vim.api.nvim_buf_get_name(0)
	local start = current ~= "" and vim.fs.dirname(current) or vim.fn.getcwd()
	return vim.fs.find({ "justfile", "Justfile", ".justfile" }, { upward = true, path = start })[1]
end

local function just_root(file)
	return file and vim.fs.dirname(file) or vim.fn.getcwd()
end

local function just_recipes(quiet)
	local file = find_justfile()
	if not file then
		if not quiet then
			vim.notify("No justfile found", vim.log.levels.INFO)
		end
		return {}, nil
	end

	local result = vim.system({ "just", "--justfile", file, "--working-directory", just_root(file), "--summary" }, {
		text = true,
	}):wait()
	if result.code ~= 0 then
		if not quiet then
			vim.notify(result.stderr ~= "" and result.stderr or "Failed to list just recipes", vim.log.levels.ERROR)
		end
		return {}, file
	end

	local recipes = {}
	for recipe in result.stdout:gmatch("%S+") do
		table.insert(recipes, recipe)
	end
	table.sort(recipes)
	return recipes, file
end

local function run_just(args)
	local file = find_justfile()
	if not file then
		vim.notify("No justfile found", vim.log.levels.INFO)
		return
	end

	if vim.fn.executable("just") == 0 then
		vim.notify("just is not installed", vim.log.levels.ERROR)
		return
	end

	local cmd = { "just", "--justfile", file, "--working-directory", just_root(file) }
	for _, arg in ipairs(args or {}) do
		table.insert(cmd, arg)
	end

	local recipe = args and args[1] or nil
	local current_tab = vim.api.nvim_get_current_tabpage()
	vim.cmd("tabnew")
	if recipe then
		vim.t.title = "Just '" .. recipe .. "'"
	end
	vim.fn.termopen(cmd, { cwd = just_root(file) })
	vim.cmd("redrawtabline")
	if vim.api.nvim_tabpage_is_valid(current_tab) then
		vim.api.nvim_set_current_tabpage(current_tab)
	end
end

local function pick_just_recipe()
	if vim.fn.executable("just") == 0 then
		vim.notify("just is not installed", vim.log.levels.ERROR)
		return
	end

	local recipes = just_recipes()
	if #recipes == 0 then
		vim.notify("No just recipes found", vim.log.levels.INFO)
		return
	end

	vim.ui.select(recipes, { prompt = "Just recipe: " }, function(recipe)
		if recipe then
			vim.schedule(function()
				run_just({ recipe })
			end)
		end
	end)
end

local function edit_justfile()
	local existing = find_justfile()
	vim.cmd("edit " .. vim.fn.fnameescape(existing or (vim.fn.getcwd() .. "/justfile")))
end

map("n", "<leader>pp", pick_just_recipe, { desc = "Pick just recipe" })
map("n", "<leader>pe", edit_justfile, { desc = "Edit justfile" })
map("n", "<leader>pI", function()
	require("project_init").pick()
end, { desc = "Initialize project files" })

vim.api.nvim_create_user_command("Just", function(opts)
	if #opts.fargs == 0 then
		pick_just_recipe()
	else
		run_just(opts.fargs)
	end
end, {
	desc = "Pick or run a just recipe",
	nargs = "*",
	complete = function(arglead, cmdline)
		local args = vim.split(cmdline, "%s+", { trimempty = true })
		if #args > 2 or (cmdline:match("%s$") and #args >= 2) then
			return {}
		end

		local recipes = just_recipes(true)
		return vim.iter(recipes)
			:filter(function(recipe)
				return recipe:find("^" .. vim.pesc(arglead)) ~= nil
			end)
			:totable()
	end,
})

vim.api.nvim_create_user_command("JustEdit", edit_justfile, { desc = "Edit or create nearest justfile" })

vim.api.nvim_create_user_command("ProjectInit", function(opts)
	if opts.args ~= "" then
		require("project_init").create(opts.args)
	else
		require("project_init").pick()
	end
end, {
	desc = "Create project scaffold files",
	nargs = "?",
	complete = function()
		return { "C++", "Lua", "Python uv", "TypeScript", "Zig" }
	end,
})

-- ── Python Environment ─────────────────────────
local function python_project_root(path)
	local start = path ~= "" and vim.fs.dirname(path) or vim.fn.getcwd()
	local marker = vim.fs.find({ "pyproject.toml", "uv.lock" }, { upward = true, path = start })[1]
	return marker and vim.fs.dirname(marker) or nil
end

local function is_python_context(bufnr)
	if vim.bo[bufnr].filetype == "python" then
		return true
	end
	return python_project_root(vim.api.nvim_buf_get_name(bufnr)) ~= nil
end

local function attach_python_env_maps(bufnr)
	if vim.b[bufnr].nvim_config_python_env_maps or not is_python_context(bufnr) then
		return
	end
	vim.b[bufnr].nvim_config_python_env_maps = true

	local opts = { buffer = bufnr }
	map("n", "<leader>pv", "<cmd>VenvSelect<cr>", vim.tbl_extend("force", opts, { desc = "Select Python venv" }))
	map("n", "<leader>pV", function()
		if vim.fn.exists(":VenvSelectCached") == 2 then
			vim.cmd("VenvSelectCached")
		else
			vim.notify(
				"VenvSelectCached is unavailable; cached venv auto-activation may be enabled",
				vim.log.levels.INFO
			)
		end
	end, vim.tbl_extend("force", opts, { desc = "Activate cached Python venv" }))
	map("n", "<leader>pX", function()
		require("venv-selector").deactivate()
	end, vim.tbl_extend("force", opts, { desc = "Deactivate Python venv" }))
	map("n", "<leader>pP", function()
		local python = require("venv-selector").python()
		vim.notify(python or "No Python venv selected", vim.log.levels.INFO)
	end, vim.tbl_extend("force", opts, { desc = "Show active Python" }))
end

-- ── LSP (on attach) ───────────────────────────
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("NvimConfigLsp", { clear = true }),
	callback = function(event)
		local m = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
		end

		m("n", "gd", function()
			require("fzf-lua").lsp_definitions()
		end, "Go to definition")
		m("n", "gD", function()
			require("fzf-lua").lsp_declarations()
		end, "Go to declaration")
		m("n", "gr", function()
			require("fzf-lua").lsp_references()
		end, "References")
		m("n", "gi", function()
			require("fzf-lua").lsp_implementations()
		end, "Implementation")
		m("n", "K", vim.lsp.buf.hover, "Hover")
		m("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
		m({ "n", "x" }, "<leader>ca", function()
			require("fzf-lua").lsp_code_actions()
		end, "Code action")
		m("n", "<leader>cs", vim.lsp.buf.signature_help, "Signature help")
		m("i", "<C-s>", vim.lsp.buf.signature_help, "Signature help")

		m("n", "<leader>ci", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end, "Toggle inlay hints")

		m("n", "<leader>cL", vim.lsp.codelens.run, "Run codelens")

		vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
	end,
})

-- ── Autocommands ───────────────────────────────
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("FileType", {
	group = augroup("NvimConfigTreesitter", { clear = true }),
	pattern = "*",
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

autocmd("TextYankPost", {
	group = augroup("NvimConfigYank", { clear = true }),
	callback = function()
		return
	end,
})

autocmd("VimResized", {
	group = augroup("NvimConfigResize", { clear = true }),
	command = "tabdo wincmd =",
})

autocmd("BufWritePre", {
	group = augroup("NvimConfigWhitespace", { clear = true }),
	pattern = "*",
	callback = function()
		if not vim.bo.modifiable then
			return
		end
		MiniTrailspace.trim()
		MiniTrailspace.trim_last_lines()
	end,
})

autocmd("BufReadPost", {
	group = augroup("NvimConfigLastPos", { clear = true }),
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local line_count = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= line_count then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

autocmd("FileType", {
	group = augroup("NvimConfigQuickClose", { clear = true }),
	pattern = { "help", "man", "qf", "checkhealth", "dap-float" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

autocmd({ "BufRead", "BufNewFile" }, {
	group = augroup("NvimConfigConanFiletype", { clear = true }),
	pattern = "conanfile.txt",
	callback = function(event)
		vim.bo[event.buf].filetype = "conan"
	end,
})

autocmd({ "BufEnter", "FileType" }, {
	group = augroup("NvimConfigPythonEnvMaps", { clear = true }),
	callback = function(event)
		attach_python_env_maps(event.buf)
	end,
})

-- Clear jumplist on startup so C-o/C-i only navigate within this session
autocmd("VimEnter", {
	group = augroup("NvimConfigCleanJumps", { clear = true }),
	callback = function()
		vim.cmd("clearjumps")
	end,
})

-- Auto-reload buffers changed on disk (e.g. by CodeCompanion's claude_code adapter)
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	group = augroup("NvimConfigAutoread", { clear = true }),
	callback = function()
		if vim.fn.getcmdwintype() == "" and vim.fn.mode() ~= "c" then
			vim.cmd("checktime")
		end
	end,
})
