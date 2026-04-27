-- ── 50_editor.lua ──────────────────────────────
-- Neovim config: Editor plugins — finder, git, navigation, formatting, and project tools.

vim.pack.add({
	-- Git
	{ src = "https://github.com/lewis6991/gitsigns.nvim", name = "gitsigns" },
	{ src = "https://github.com/refractalize/oil-git-status.nvim", name = "oil-git-status" },

	-- Diagnostics, outline, and code navigation
	{ src = "https://github.com/stevearc/aerial.nvim", name = "aerial" },
	{ src = "https://github.com/oribarilan/lensline.nvim", name = "lensline" },
	{ src = "https://github.com/folke/trouble.nvim", name = "trouble" },

	-- C/C++ memory layout inspection
	{ src = "https://github.com/J-Cowsert/classlayout.nvim", name = "classlayout" },

	-- Folding
	{ src = "https://github.com/kevinhwang91/nvim-ufo", name = "nvim-ufo" },
	{ src = "https://github.com/kevinhwang91/promise-async", name = "promise-async" },

	-- File navigation
	{ src = "https://github.com/ThePrimeagen/harpoon", name = "harpoon", version = "harpoon2" },
	{ src = "https://github.com/nvim-lua/plenary.nvim", name = "plenary" },
	{ src = "https://github.com/stevearc/oil.nvim", name = "oil" },

	-- Formatting
	{ src = "https://github.com/stevearc/conform.nvim", name = "conform" },

	-- Treesitter
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", name = "nvim-treesitter" },

	-- Markdown rendering
	{ src = "https://github.com/OXY2DEV/markview.nvim", name = "markview" },

	-- Inline image rendering (required by diagram.nvim)
	{ src = "https://github.com/3rd/image.nvim", name = "image" },

	-- Inline diagram rendering (mermaid, etc.)
	{ src = "https://github.com/3rd/diagram.nvim", name = "diagram" },

	-- Live preview (browser-based for MD/HTML/SVG)
	{ src = "https://github.com/brianhuster/live-preview.nvim", name = "live-preview" },

	-- HTTP client
	{ src = "https://github.com/mistweaverco/kulala.nvim", name = "kulala" },

	-- Venv selector
	{ src = "https://github.com/linux-cultist/venv-selector.nvim", name = "venv-selector" },

	-- Highlight Colors (CSS, Tailwind)
	{ src = "https://github.com/brenoprata10/nvim-highlight-colors", name = "nvim-highlight-colors" },

	-- Fuzzy finder
	{ src = "https://github.com/ibhagwan/fzf-lua", name = "fzf-lua" },
})

vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>", { desc = "File explorer" })
vim.keymap.set("n", "<leader>E", function()
	vim.cmd("tabnew")
	vim.cmd("Oil " .. vim.fn.getcwd())
end, { desc = "File explorer (tab)" })

require("oil").setup({
	default_file_explorer = true,
	view_options = {
		show_hidden = true,
	},
	win_options = {
		signcolumn = "yes:2",
	},
})

require("oil-git-status").setup()

require("lensline").setup({
	profiles = {
		{
			name = "default",
			providers = {
				{
					name = "usages",
					enabled = true,
					include = { "refs" },
					breakdown = false,
					show_zero = false,
				},
				{
					name = "last_author",
					enabled = true,
				},
			},
			style = {
				placement = "inline",
				prefix = "",
				render = "focused",
			},
		},
	},
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("NvimConfigOilKeymaps", { clear = true }),
	pattern = "oil",
	callback = function(event)
		vim.keymap.set("n", "q", function()
			local alt = vim.fn.bufnr("#")
			if alt > 0 and vim.api.nvim_buf_is_valid(alt) then
				vim.cmd("buffer #")
			elseif vim.fn.winnr("$") > 1 then
				vim.cmd("close")
			else
				vim.cmd("enew")
			end
		end, { buffer = event.buf, desc = "Back to previous buffer" })
	end,
})

-- ── Aerial ─────────────────────────────────────
require("aerial").setup({
	backends = {
		["_"] = { "lsp", "treesitter", "markdown", "man" },
		json = { "treesitter" },
		jsonc = { "treesitter" },
	},
	default_bindings = true,
	filter_kind = {
		["_"] = {
			"Class",
			"Constructor",
			"Enum",
			"Function",
			"Interface",
			"Module",
			"Method",
			"Struct",
		},
		json = false,
		jsonc = false,
	},
	keymaps = {
		["?"] = "actions.show_help",
		["g?"] = "actions.show_help",
		["<CR>"] = "actions.jump",
		["<2-LeftMouse>"] = "actions.jump",
		["<C-v>"] = "actions.jump_vsplit",
		["<C-s>"] = "actions.jump_split",
		["p"] = "actions.scroll",
		["<C-j>"] = "actions.down_and_scroll",
		["<C-k>"] = "actions.up_and_scroll",
		["{"] = "actions.prev",
		["}"] = "actions.next",
		["[["] = "actions.prev_up",
		["]]"] = "actions.next_up",
		["q"] = "actions.close",
		["o"] = "actions.tree_toggle",
		["za"] = "actions.tree_toggle",
		["O"] = "actions.tree_toggle_recursive",
		["zA"] = "actions.tree_toggle_recursive",
		["h"] = "actions.tree_close",
		["l"] = "actions.tree_open",
		["H"] = "actions.tree_close_recursive",
		["L"] = "actions.tree_open_recursive",
		["zM"] = "actions.tree_close_all",
		["zR"] = "actions.tree_open_all",
	},
	layout = {
		default_direction = "right",
		min_width = 28,
	},
	on_attach = function(bufnr)
		vim.keymap.set("n", "{", "<cmd>AerialPrev<cr>", { buffer = bufnr, desc = "Previous symbol" })
		vim.keymap.set("n", "}", "<cmd>AerialNext<cr>", { buffer = bufnr, desc = "Next symbol" })
	end,
	show_guides = true,
})

vim.keymap.set("n", "<leader>co", "<cmd>AerialToggle<cr>", { desc = "Code outline" })

-- ── Trouble ────────────────────────────────────
require("trouble").setup({
	focus = false,
	modes = {
		symbols = {
			groups = {
				{ "filename", format = "{file_icon} {basename} {count}" },
			},
		},
	},
})

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble diagnostics" })
vim.keymap.set(
	"n",
	"<leader>xX",
	"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
	{ desc = "Trouble buffer diagnostics" }
)
vim.keymap.set(
	"n",
	"<leader>xl",
	"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
	{ desc = "Trouble LSP locations" }
)
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Trouble location list" })
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Trouble quickfix list" })

-- ── fzf-lua ───────────────────────────────────
local fzf = require("fzf-lua")

-- Anchor float to bottom-left, just above the statusline
local function fzf_bottom(h, w, preview)
	local ch = vim.o.cmdheight
	local win_h = math.floor((vim.o.lines - ch) * h)
	local sl = (vim.o.laststatus > 0) and 1 or 0
	return {
		height = h,
		width = w,
		row = math.max(0, vim.o.lines - ch - sl - win_h),
		col = 0,
		preview = preview or { hidden = "hidden" },
	}
end

local preview_winopts = { hidden = "nohidden", layout = "horizontal", horizontal = "right:55%" }

local function fzf_titled(title, h, w, preview)
	return function()
		return vim.tbl_extend("force", fzf_bottom(h, w, preview), { title = title })
	end
end

fzf.setup({
	"default-title",
	fzf_colors = true,
	winopts = vim.tbl_extend("force", fzf_bottom(0.35, 0.45), { winhl = true }),
	hls = {
		backdrop = "FzfLuaBackdrop",
		border = "FzfLuaBorder",
		title = "FzfLuaTitle",
		normal = "FzfLuaNormal",
		cursorline = "FzfLuaCursorLine",
		preview_border = "FzfLuaPreviewBorder",
		preview_normal = "FzfLuaPreviewNormal",
		preview_title = "FzfLuaPreviewTitle",
		fzf = {
			border = "FzfLuaFzfBorder",
			cursorline = "FzfLuaFzfCursorLine",
			gutter = "FzfLuaFzfGutter",
			header = "FzfLuaFzfHeader",
			info = "FzfLuaFzfInfo",
			marker = "FzfLuaFzfMarker",
			match = "FzfLuaFzfMatch",
			normal = "FzfLuaFzfNormal",
			pointer = "FzfLuaFzfPointer",
			prompt = "FzfLuaFzfPrompt",
			query = "FzfLuaFzfQuery",
		},
	},
	keymap = {
		fzf = {
			["alt-j"] = "down",
			["alt-k"] = "up",
		},
	},
	files = {
		fd_opts = "--color=never --type f --follow --exclude .git",
		hidden = false,
		prompt = "Files: ",
		winopts = fzf_titled("Files", 0.75, 0.80, preview_winopts),
	},
	grep = {
		input_prompt = "Grep: ",
		prompt = "Matches: ",
		winopts = fzf_titled("Grep", 0.75, 0.80, preview_winopts),
	},
	lsp = {
		prompt = "LSP: ",
		winopts = fzf_titled("LSP", 0.75, 0.80, preview_winopts),
	},
	git = {
		prompt = "Git: ",
		winopts = fzf_titled("Git", 0.75, 0.80, preview_winopts),
	},
	helptags = {
		prompt = "Help: ",
		winopts = fzf_titled("Help", 0.75, 0.80, preview_winopts),
	},
	oldfiles = {
		prompt = "Recent: ",
		winopts = fzf_titled("Recent", 0.75, 0.80, preview_winopts),
	},
	buffers = {
		prompt = "Buffers: ",
		winopts = function()
			local count = #vim.fn.getbufinfo({ buflisted = 1 })
			local h = math.max(0.20, math.min(0.50, (count + 4) / vim.o.lines))
			return vim.tbl_extend("force", fzf_bottom(h, 0.45), { title = "Buffers" })
		end,
	},
	diagnostics = {
		prompt = "Diagnostics: ",
		winopts = fzf_titled("Diagnostics", 0.75, 0.80, preview_winopts),
	},
	marks = {
		prompt = "Marks: ",
		winopts = fzf_titled("Marks", 0.50, 0.55, preview_winopts),
	},
	registers = {
		prompt = "Registers: ",
		winopts = fzf_titled("Registers", 0.50, 0.55),
	},
	keymaps = {
		prompt = "Keymaps: ",
		winopts = fzf_titled(
			"Keymaps",
			0.70,
			0.72,
			{ hidden = "nohidden", layout = "vertical", vertical = "down:45%" }
		),
	},
})
fzf.register_ui_select(function(_, items)
	local count = #items
	local h = math.max(0.15, math.min(0.50, (count + 4) / vim.o.lines))
	local w = math.max(0.25, math.min(0.50, 0.02 * count + 0.20))
	return { winopts = vim.tbl_extend("force", fzf_bottom(h, w), { title = "Select" }) }
end)

do
	local fzf_config = require("fzf-lua.config")
	local trouble_actions = require("trouble.sources.fzf").actions
	fzf_config.defaults.actions.files["ctrl-t"] = trouble_actions.open
end

vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("NvimConfigTerminalTheme", { clear = true }),
	callback = function(args)
		local winid = vim.fn.bufwinid(args.buf)
		if winid == -1 then
			return
		end
		vim.wo[winid].winhighlight = "Normal:Normal,NormalNC:Normal,CursorLine:CursorLine"
		vim.wo[winid].winbar = ""
		vim.wo[winid].cursorline = false
	end,
})

vim.keymap.set("n", "<leader><space>", fzf.files, { desc = "Find files" })
vim.keymap.set("n", "ff", fzf.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>/", fzf.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>jj", function()
	MiniJump2d.start(MiniJump2d.builtin_opts.single_character)
end, { desc = "Jump2d" })
vim.keymap.set("n", "<leader>b", fzf.buffers, { desc = "Buffer switcher" })
vim.keymap.set("n", "<leader><Tab>", "<cmd>b#<cr>", { desc = "Alternate buffer" })
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", fzf.helptags, { desc = "Help" })
vim.keymap.set("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
vim.keymap.set("n", "<leader>fd", fzf.diagnostics_document, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>fs", fzf.lsp_document_symbols, { desc = "Symbols" })
vim.keymap.set("n", "<leader>fS", fzf.lsp_workspace_symbols, { desc = "Workspace symbols" })
vim.keymap.set("n", "<leader>fg", fzf.git_status, { desc = "Git status" })
vim.keymap.set("n", "<leader>fl", fzf.git_commits, { desc = "Git log" })
vim.keymap.set("n", "<leader>fL", fzf.git_bcommits, { desc = "Buffer git log" })
local function find_todos()
	fzf.grep_project({
		search = [[\b(TODO|FIXME|HACK|NOTE|XXX|BUG|WARN|WARNING|PERF|OPTIMIZE|REVIEW|IDEA)\b]],
		no_esc = true,
		title = "Todos",
	})
end

vim.api.nvim_create_user_command("TodoList", find_todos, { desc = "List project TODO comments" })
vim.keymap.set("n", "<leader>fT", find_todos, { desc = "Todos" })
vim.keymap.set("n", "<leader>fw", fzf.grep_cword, { desc = "Grep word" })
vim.keymap.set("v", "<leader>fw", fzf.grep_visual, { desc = "Grep selection" })
vim.keymap.set("n", "<leader>fm", fzf.marks, { desc = "Marks" })
vim.keymap.set("n", "<leader>fR", fzf.registers, { desc = "Registers" })
vim.keymap.set("n", "<leader>fK", fzf.keymaps, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>ft", fzf.resume, { desc = "Resume last picker" })

-- ── Gitsigns ───────────────────────────────────
require("gitsigns").setup({
	signs = {
		add = { text = "▎" },
		change = { text = "▎" },
		delete = { text = "▁" },
		topdelete = { text = "▔" },
		changedelete = { text = "▎" },
		untracked = { text = "▎" },
	},
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns
		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
		end
		map("n", "]h", gs.next_hunk, "Next hunk")
		map("n", "[h", gs.prev_hunk, "Prev hunk")
		map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
		map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
		map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
		map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
		map("n", "<leader>gi", gs.preview_hunk, "Inspect hunk")
		map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
		map("n", "<leader>gb", function()
			gs.blame_line({ full = true })
		end, "Blame line")
		map("n", "<leader>gd", gs.diffthis, "Diff this")
	end,
})

local function open_gitui()
	if vim.fn.executable("gitui") ~= 1 then
		vim.notify("gitui is not installed or not on PATH", vim.log.levels.ERROR)
		return
	end

	vim.cmd("tabnew")
	vim.cmd("terminal gitui")
	vim.cmd("startinsert")
	vim.api.nvim_create_autocmd("TermClose", {
		once = true,
		buffer = 0,
		callback = function()
			vim.cmd("tabclose")
		end,
	})
end

vim.keymap.set("n", "<leader>gg", open_gitui, { desc = "Gitui" })
vim.keymap.set("n", "<leader>gG", open_gitui, { desc = "Gitui" })

-- ── ClassLayout ────────────────────────────────
local classlayout = require("classlayout")

local function classlayout_split_blocks(output)
	local blocks = {}
	local current = {}
	local in_block = false

	for line in output:gmatch("[^\n]+") do
		if line:match("%*%*%* Dumping AST Record Layout") then
			if #current > 0 then
				blocks[#blocks + 1] = current
			end
			current = {}
			in_block = true
		elseif in_block then
			current[#current + 1] = line
		end
	end

	if #current > 0 then
		blocks[#blocks + 1] = current
	end

	return blocks
end

local function classlayout_type_from_block(block)
	local line = block[1]
	if not line then
		return nil
	end

	local full_type = line:match("^%s*%d+%s*|%s*[%w_]+%s+(.+)$")
	if not full_type then
		return nil
	end

	full_type = full_type:gsub("%s*%(empty%)%s*$", "")
	full_type = full_type:gsub("%s*%(sizeof.*$", "")
	return vim.trim(full_type)
end

local function classlayout_name_variants(kind, name)
	local variants = {}
	local function add(value)
		if value and value ~= "" and not vim.tbl_contains(variants, value) then
			variants[#variants + 1] = value
		end
	end

	add(name)
	add((name or ""):match("::([%w_]+)$"))
	add(kind and name and (kind .. " " .. name) or nil)
	add(kind and name and (kind .. " " .. ((name or ""):match("::([%w_]+)$") or name)) or nil)
	return variants
end

local function classlayout_matches_type(full_type, candidates)
	if not full_type then
		return false
	end

	local stripped = full_type:gsub("<.+>", "")
	local unqualified = stripped:match("::([%w_]+)$") or stripped
	local normalized = {
		full_type,
		stripped,
		unqualified,
		full_type:gsub("^(struct|class|union)%s+", ""),
		stripped:gsub("^(struct|class|union)%s+", ""),
		unqualified:gsub("^(struct|class|union)%s+", ""),
	}

	for _, candidate in ipairs(candidates) do
		for _, value in ipairs(normalized) do
			if value == candidate then
				return true
			end
		end
	end

	return false
end

local function classlayout_parse_any(output, candidates)
	for _, block in ipairs(classlayout_split_blocks(output)) do
		if classlayout_matches_type(classlayout_type_from_block(block), candidates) then
			return block
		end
	end
	return nil
end

local function classlayout_find_typedef_alias(start_line)
	local depth = 0

	for line_nr = start_line, vim.api.nvim_buf_line_count(0) do
		local line = vim.api.nvim_buf_get_lines(0, line_nr - 1, line_nr, false)[1] or ""
		for char in line:gmatch("[{}]") do
			depth = depth + (char == "{" and 1 or -1)
		end

		if depth <= 0 then
			return line:match("}%s*([%w_]+)%s*[,;]")
		end
	end

	return nil
end

local function classlayout_record_at_line(line, line_nr)
	local typedef, kind, rest = line:match("^%s*(typedef%s+)(struct|class|union)%s*(.*)$")
	if not kind then
		kind, rest = line:match("^%s*(struct|class|union)%s*(.*)$")
	end
	if not kind then
		return nil
	end

	rest = rest:gsub("^__attribute__%s*%b()%s*", "")
	rest = rest:gsub("^%[%[[^%]]+%]%]%s*", "")

	local name = rest:match("^([%w_:]+)")
	if name == "final" or name == "alignas" then
		name = nil
	end
	if (not name or name == "") and typedef then
		name = classlayout_find_typedef_alias(line_nr)
	end
	if not name or name == "" then
		return nil
	end

	return { kind = kind, name = name, line_nr = line_nr }
end

local function classlayout_find_enclosing_record()
	local current_line = vim.api.nvim_win_get_cursor(0)[1]

	for line_nr = current_line, 1, -1 do
		local line = vim.api.nvim_buf_get_lines(0, line_nr - 1, line_nr, false)[1] or ""
		local record = classlayout_record_at_line(line, line_nr)
		if record and (line:find("{", 1, true) or line_nr < current_line) then
			return record
		end
	end

	return nil
end

local function show_classlayout()
	local ft = vim.bo.filetype
	if ft ~= "c" and ft ~= "cpp" then
		classlayout.show()
		return
	end

	local filepath = vim.api.nvim_buf_get_name(0)
	if filepath == "" then
		vim.notify("ClassLayout: buffer has no file", vim.log.levels.WARN)
		return
	end

	local record = classlayout_find_enclosing_record()
	if not record then
		classlayout.show()
		return
	end

	local compiler = classlayout.config.compiler or "clang"
	if vim.fn.executable(compiler) ~= 1 then
		vim.notify("ClassLayout: '" .. compiler .. "' not found in PATH", vim.log.levels.ERROR)
		return
	end

	local args = { compiler, "-Xclang", "-fdump-record-layouts-complete", "-fsyntax-only" }
	if ft == "cpp" or record.kind == "class" then
		args[#args + 1] = "-x"
		args[#args + 1] = "c++"
	end
	args[#args + 1] = filepath

	if classlayout.config.compile_commands then
		for _, flag in ipairs(classlayout.get_compile_flags(filepath)) do
			args[#args + 1] = flag
		end
	end

	for _, arg in ipairs(classlayout.config.args or {}) do
		args[#args + 1] = arg
	end

	local result = vim.system(args, { text = true }):wait()
	local output = (result.stdout or "") .. (result.stderr or "")
	local candidates = classlayout_name_variants(record.kind, record.name)
	local block = classlayout_parse_any(output, candidates)

	if block then
		classlayout.open_float(block, record.name)
		return
	end

	local available = {}
	for _, dump_block in ipairs(classlayout_split_blocks(output)) do
		local type_name = classlayout_type_from_block(dump_block)
		if type_name then
			available[#available + 1] = type_name
		end
	end

	local message = string.format(
		"ClassLayout: no layout found for '%s'. clang exit=%s. Dumped: %s",
		record.name,
		result.code or "?",
		#available > 0 and table.concat(vim.list_slice(available, 1, 8), ", ") or "none"
	)
	vim.notify(message, vim.log.levels.WARN)
end

classlayout.setup({
	keymap = "<leader>cl",
	compiler = "clang",
	compile_commands = true,
})

vim.api.nvim_create_user_command("ClassLayoutHere", show_classlayout, {
	desc = "Show class memory layout for symbol or enclosing C/C++ type",
})

-- ── UFO (folding) ──────────────────────────────
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

require("ufo").setup({
	provider_selector = function(_, filetype, _)
		if filetype == "markdown" then
			return { "treesitter", "indent" }
		end
		return { "lsp", "indent" }
	end,
})

vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
vim.keymap.set("n", "zK", function()
	local winid = require("ufo").peekFoldedLinesUnderCursor()
	if not winid then
		vim.lsp.buf.hover()
	end
end, { desc = "Peek fold" })

-- ── Harpoon ─────────────────────────────
local harpoon = require("harpoon")
harpoon:setup({
	settings = {
		save_on_toggle = false,
		sync_on_ui_close = false,
	},
})

local harpoon_extensions = require("harpoon.extensions")
harpoon:extend(harpoon_extensions.builtins.highlight_current_file())

harpoon:extend({
	ADD = function()
		vim.cmd("redrawtabline")
	end,
	REMOVE = function()
		vim.cmd("redrawtabline")
	end,
	LIST_CHANGE = function()
		vim.cmd("redrawtabline")
	end,
	UI_CREATE = function(cx)
		vim.keymap.set("n", "<C-v>", function()
			harpoon.ui:select_menu_item({ vsplit = true })
		end, { buffer = cx.bufnr })
		vim.keymap.set("n", "<C-x>", function()
			harpoon.ui:select_menu_item({ split = true })
		end, { buffer = cx.bufnr })
		vim.keymap.set("n", "<C-t>", function()
			harpoon.ui:select_menu_item({ tabedit = true })
		end, { buffer = cx.bufnr })
	end,
})

local function harpoon_picker_label(path)
	local rel = vim.fn.fnamemodify(path, ":~:.")
	local name = vim.fn.fnamemodify(rel, ":t")
	local dir = vim.fn.fnamemodify(rel, ":h")
	local icon = ""
	if _G.MiniIcons then
		local icon_text = select(1, MiniIcons.get("file", path))
		if icon_text and icon_text ~= "" then
			icon = icon_text .. " "
		end
	end
	if dir == "." or dir == "" then
		return icon .. name
	end
	return string.format("%s%s  %s", icon, name, dir)
end

-- File marks
vim.keymap.set("n", "<leader>ha", function()
	harpoon:list():add()
end, { desc = "Harpoon add" })
vim.keymap.set("n", "<leader>hd", function()
	local list = harpoon:list()
	local item = list.config.create_list_item(list.config)
	for _, v in ipairs(list.items) do
		if list.config.equals(v, item) then
			list:remove(item)
			return
		end
	end
	vim.notify("File not in harpoon list", vim.log.levels.WARN)
end, { desc = "Harpoon remove current" })
vim.keymap.set("n", "<leader>hc", function()
	local list = harpoon:list()
	if #list.items == 0 then
		vim.notify("Harpoon list is already empty", vim.log.levels.INFO)
		return
	end
	list:clear()
	harpoon:sync()
	vim.cmd("redrawtabline")
	vim.notify("Cleared harpoon list", vim.log.levels.INFO)
end, { desc = "Harpoon clear" })
vim.keymap.set("n", "<leader>1", function()
	harpoon:list():select(1)
end, { desc = "Harpoon 1" })
vim.keymap.set("n", "<leader>2", function()
	harpoon:list():select(2)
end, { desc = "Harpoon 2" })
vim.keymap.set("n", "<leader>3", function()
	harpoon:list():select(3)
end, { desc = "Harpoon 3" })
vim.keymap.set("n", "<leader>4", function()
	harpoon:list():select(4)
end, { desc = "Harpoon 4" })
vim.keymap.set("n", "<C-S-P>", function()
	harpoon:list():prev()
end, { desc = "Harpoon prev" })
vim.keymap.set("n", "<C-S-N>", function()
	harpoon:list():next()
end, { desc = "Harpoon next" })

vim.keymap.set("n", "<leader>hh", function()
	local items = harpoon:list().items
	if #items == 0 then
		vim.notify("Harpoon list is empty", vim.log.levels.INFO)
		return
	end

	local files = {}
	for _, item in ipairs(items) do
		local path = item.value or ""
		if path ~= "" then
			local label = harpoon_picker_label(path)
			table.insert(files, label .. "\t" .. path)
		end
	end

	fzf.fzf_exec(files, {
		prompt = "Harpoon> ",
		fzf_opts = {
			["--delimiter"] = "\t",
			["--with-nth"] = "1",
		},
		actions = {
			["default"] = function(selected)
				if selected and selected[1] then
					local path = selected[1]:match("\t(.+)$") or selected[1]
					vim.cmd("edit " .. vim.fn.fnameescape(path))
				end
			end,
		},
	})
end, { desc = "Harpoon menu" })
-- ── Conform ────────────────────────────────────
require("conform").setup({
	format_on_save = function(bufnr)
		if vim.bo[bufnr].filetype == "oil" then
			return
		end
		return {
			timeout_ms = 500,
			lsp_format = "fallback",
		}
	end,
	log_level = vim.log.levels.WARN,
	notify_on_error = true,
	notify_no_formatters = true,
	formatters_by_ft = {
		c = { "clang_format" },
		cmake = { "gersemi" },
		cpp = { "clang_format" },
		css = { "biome" },
		dockerfile = { "dockerfmt" },
		fish = { "fish_indent" },
		html = { "superhtml" },
		javascript = { "biome" },
		javascriptreact = { "biome" },
		json = { "biome" },
		jsonc = { "biome" },
		just = { "just" },
		lua = { "stylua" },
		python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
		typescript = { "biome" },
		typescriptreact = { "biome" },
		["yaml.docker-compose"] = { "yamlfmt" },
		zig = { "zigfmt" },
	},
	formatters = {
		clang_format = {
			command = "/opt/homebrew/opt/llvm/bin/clang-format",
		},
		gersemi = {
			command = "gersemi",
			args = { "-" },
		},
		just = {
			command = "just",
			args = { "--fmt", "--unstable", "-f", "$FILENAME" },
			stdin = false,
		},
	},
})

-- ── Treesitter ─────────────────────────────────
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		if pcall(vim.treesitter.start) then
			if vim.bo.filetype == "python" then
				return
			end
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})
require("nvim-treesitter").setup({
	ensure_installed = {
		"bash",
		"c",
		"cmake",
		"css",
		"cpp",
		"dockerfile",
		"fish",
		"javascript",
		"just",
		"html",
		"http",
		"json",
		"latex",
		"lua",
		"markdown",
		"markdown_inline",
		"python",
		"query",
		"toml",
		"tsx",
		"typescript",
		"vimdoc",
		"yaml",
		"zig",
	},
})

local function refresh_markview_highlights()
	local ok, markview_highlights = pcall(require, "markview.highlights")
	if not ok then
		return
	end

	for _, group in ipairs(vim.fn.getcompletion("Markview", "highlight")) do
		vim.api.nvim_set_hl(0, group, {})
	end
	markview_highlights.setup()
end

local function mermaid_theme()
	return vim.o.background == "dark" and "dark" or "neutral"
end

local function refresh_diagram_mermaid_theme(render_current)
	local ok, diagram = pcall(require, "diagram")
	if not ok then
		return
	end

	local _, state = debug.getupvalue(diagram.setup, 1)
	if type(state) == "table" then
		state.renderer_options = state.renderer_options or {}
		state.renderer_options.mermaid = vim.tbl_deep_extend("force", state.renderer_options.mermaid or {}, {
			theme = mermaid_theme(),
			scale = 2,
		})
	end

	local cache_dir = vim.fn.stdpath("cache") .. "/diagram-cache/mermaid"
	vim.fn.delete(cache_dir, "rf")
	vim.fn.mkdir(cache_dir, "p")

	if render_current then
		vim.schedule(function()
			if vim.bo.filetype ~= "markdown" then
				return
			end
			pcall(diagram.clear)
			pcall(diagram.render)
		end)
	end
end

-- ── Markview (markdown rendering) ──────────────
require("markview").setup({
	preview = {
		icon_provider = "mini",
		filetypes = { "markdown" },
		ignore_buftypes = {},
	},
	markdown = {
		code_blocks = {
			["mermaid"] = {
				block_hl = "MarkviewPalette5",
				pad_hl = "MarkviewPalette5",
			},
		},
	},
})
refresh_markview_highlights()

-- ── image.nvim ─────────────────────────────────
require("image").setup({
	backend = "kitty",
	processor = "magick_cli",
	integrations = {},
	max_width_window_percentage = 60,
	max_height_window_percentage = 40,
	hijack_file_patterns = {},
})

-- ── diagram.nvim ────────────────────────────────
require("diagram").setup({
	integrations = {
		require("diagram.integrations.markdown"),
	},
	renderer_options = {
		mermaid = {
			theme = mermaid_theme(),
			scale = 2,
		},
	},
})
refresh_diagram_mermaid_theme(false)

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("NvimConfigMarkdownThemeRefresh", { clear = true }),
	callback = function()
		refresh_markview_highlights()
		refresh_diagram_mermaid_theme(true)
	end,
})

-- ── Live Preview (browser) ─────────────────────
require("livepreview.config").set({})

vim.keymap.set("n", "<leader>mp", "<cmd>LivePreview start<cr>", { desc = "Start live preview" })
vim.keymap.set("n", "<leader>ms", "<cmd>LivePreview stop<cr>", { desc = "Stop live preview" })
vim.keymap.set("n", "<leader>mf", "<cmd>LivePreview pick<cr>", { desc = "Pick file to preview" })

-- ── Kulala (HTTP) ──────────────────────────────
require("kulala").setup({
	default_view = "body",
	default_env = "dev",
	contenttypes = {
		["application/graphql"] = {
			ft = "graphql",
			formatter = vim.fn.executable("biome") == 1 and { "biome", "format", "--stdin-file-path", "file.graphql" },
			pathresolver = nil,
		},
		["application/javascript"] = {
			ft = "javascript",
			formatter = vim.fn.executable("biome") == 1 and { "biome", "format", "--stdin-file-path", "file.js" },
			pathresolver = nil,
		},
		["text/html"] = {
			ft = "html",
			formatter = vim.fn.executable("superhtml") == 1 and { "superhtml", "fmt", "--stdin" },
			pathresolver = nil,
		},
	},
})

vim.keymap.set({ "n", "v" }, "<leader>kr", function()
	require("kulala").run()
end, { desc = "Run HTTP request" })
vim.keymap.set("n", "<leader>kR", function()
	require("kulala.ui").show_script_output()
end, { desc = "Show HTTP script output" })
vim.keymap.set("n", "<leader>ke", function()
	require("kulala").set_selected_env()
end, { desc = "Select HTTP environment" })

-- ── Venv Selector ──────────────────────────────
require("venv-selector").setup({
	name = { "venv", ".venv", "env", ".env" },
	auto_refresh = true,
})

-- ── NVIM Highlight Colors ──────────────────────
require("nvim-highlight-colors").setup({
	render = "virtual",
	virtual_symbol = "●",
	enable_hex = true,
	enable_short_hex = true,
	enable_rgb = true,
	enable_hsl = true,
	enable_css_variables = true,
	enable_named_colors = true,
	enable_tailwind = true,
})
