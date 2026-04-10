-- ── 50_editor.lua ──────────────────────────────
-- Neovim config: Editor plugins — finder, git, navigation, formatting, testing, commands.

vim.pack.add({
	-- Git
	"https://github.com/lewis6991/gitsigns.nvim",

	-- Code outline
	"https://github.com/stevearc/aerial.nvim",
	"https://github.com/Sang-it/fluoride",

	-- Folding
	"https://github.com/kevinhwang91/nvim-ufo",
	"https://github.com/kevinhwang91/promise-async",

	-- File navigation
	{ src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
	"https://github.com/nvim-lua/plenary.nvim",

	-- Formatting
	"https://github.com/stevearc/conform.nvim",

	-- Treesitter
	"https://github.com/nvim-treesitter/nvim-treesitter",

	-- Markdown rendering
	"https://github.com/OXY2DEV/markview.nvim",

	-- Image paste
	"https://github.com/HakonHarnes/img-clip.nvim",

	-- Live preview (browser-based for MD/HTML/SVG)
	"https://github.com/brianhuster/live-preview.nvim",

	-- Testing
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/nvim-neotest/neotest",
	"https://github.com/nvim-neotest/neotest-python",
	"https://github.com/alfaix/neotest-gtest",
	"https://github.com/lawrence-laz/neotest-zig",
	-- HTTP client
	"https://github.com/mistweaverco/kulala.nvim",

	-- Venv selector
	"https://github.com/linux-cultist/venv-selector.nvim",

	-- Highlight Colors (CSS, Tailwind)
	"https://github.com/brenoprata10/nvim-highlight-colors",

	-- Fuzzy finder
	"https://github.com/ibhagwan/fzf-lua",
})

local function open_mini_files(path, use_latest)
	local target = path
	if not target or target == "" or vim.fn.filereadable(target) == 0 and vim.fn.isdirectory(target) == 0 then
		target = vim.fn.getcwd()
	end
	require("mini.files").open(target, use_latest)
end

vim.keymap.set("n", "-", function()
	local path = vim.api.nvim_buf_get_name(0)
	if path == "" or vim.fn.filereadable(path) == 0 and vim.fn.isdirectory(path) == 0 then
		path = vim.fn.getcwd()
	end
	open_mini_files(path, false)
end, { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>e", function()
	local path = vim.api.nvim_buf_get_name(0)
	if path == "" or vim.fn.filereadable(path) == 0 and vim.fn.isdirectory(path) == 0 then
		path = vim.fn.getcwd()
	end
	open_mini_files(path, false)
end, { desc = "File explorer" })
vim.keymap.set("n", "<leader>E", function()
	vim.cmd("tabnew")
	local path = vim.fn.getcwd()
	open_mini_files(path, false)
end, { desc = "File explorer (tab)" })

-- ── fzf-lua ───────────────────────────────────
local fzf = require("fzf-lua")

local with_preview = {
	height = 0.75,
	width = 0.80,
	row = 1,
	col = 0,
	preview = { hidden = "nohidden", layout = "horizontal", horizontal = "right:55%" },
}

fzf.setup({
	"default-title",
	winopts = {
		height = 0.35,
		width = 0.45,
		row = 1,
		col = 0,
		preview = { hidden = "hidden" },
	},
	keymap = {
		fzf = {
			["alt-j"] = "down",
			["alt-k"] = "up",
		},
	},
	files = { fd_opts = "--color=never --type f --hidden --follow --exclude .git", winopts = with_preview },
	grep = { winopts = with_preview },
	lsp = { winopts = with_preview },
	git = { winopts = with_preview },
	helptags = { winopts = with_preview },
	oldfiles = { winopts = with_preview },
	buffers = {
		winopts = function()
			local count = #vim.fn.getbufinfo({ buflisted = 1 })
			local h = math.max(0.20, math.min(0.50, (count + 4) / vim.o.lines))
			return { height = h, width = 0.45, row = 1, col = 0, preview = { hidden = "hidden" } }
		end,
	},
})
fzf.register_ui_select(function(_, items)
	local count = #items
	local h = math.max(0.15, math.min(0.50, (count + 4) / vim.o.lines))
	local w = math.max(0.25, math.min(0.50, 0.02 * count + 0.20))
	return { winopts = { height = h, width = w, row = 1, col = 0 } }
end)

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
		map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
		map("n", "<leader>gb", function()
			gs.blame_line({ full = true })
		end, "Blame line")
		map("n", "<leader>gd", gs.diffthis, "Diff this")
	end,
})

-- ── Aerial ─────────────────────────────────────
require("aerial").setup({
	backends = { "lsp", "treesitter", "markdown" },
	layout = { min_width = 30, default_direction = "right" },
	show_guides = true,
	filter_kind = false,
})

vim.keymap.set("n", "<leader>co", "<cmd>AerialToggle<cr>", { desc = "Code outline" })
vim.keymap.set("n", "{", "<cmd>AerialPrev<cr>", { desc = "Prev symbol" })
vim.keymap.set("n", "}", "<cmd>AerialNext<cr>", { desc = "Next symbol" })

-- ── Fluoride ───────────────────────────────────
vim.keymap.set("n", "<leader>cS", "<cmd>Fluoride<cr>", { desc = "Symbol structure" })

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
			table.insert(files, path)
		end
	end

	fzf.fzf_exec(files, {
		prompt = "Harpoon> ",
		actions = {
			["default"] = function(selected)
				if selected and selected[1] then
					vim.cmd("edit " .. selected[1])
				end
			end,
		},
	})
end, { desc = "Harpoon menu" })
-- ── Conform ────────────────────────────────────
require("conform").setup({
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		c = { "clang_format" },
		cpp = { "clang_format" },
		css = { "biome" },
		fish = { "fish_indent" },
		html = { "superhtml" },
		javascript = { "biome" },
		javascriptreact = { "biome" },
		json = { "biome" },
		jsonc = { "biome" },
		just = { "just" },
		lua = { "stylua" },
		python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
		typescript = { "biome" },
		typescriptreact = { "biome" },
		zig = { "zigfmt" },
	},
	formatters = {
		clang_format = {
			command = "/opt/homebrew/opt/llvm/bin/clang-format",
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
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})
require("nvim-treesitter").setup({
	ensure_installed = {
		"bash",
		"c",
		"css",
		"cpp",
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

-- ── Markview (markdown rendering) ──────────────
require("markview").setup({
	preview = {
		icon_provider = "mini",
		filetypes = { "markdown" },
		ignore_buftypes = {},
	},
})

-- ── img-clip (image paste) ─────────────────────
require("img-clip").setup({
	default = {
		embed_image_as_base64 = false,
		prompt_for_file_name = false,
		drag_and_drop = {
			insert_mode = true,
		},
	},
})

vim.keymap.set({ "n", "v" }, "<leader>pi", "<cmd>PasteImage<cr>", { desc = "Paste image" })

-- ── Live Preview (browser) ─────────────────────
require("livepreview.config").set({})

vim.keymap.set("n", "<leader>mp", "<cmd>LivePreview start<cr>", { desc = "Start live preview" })
vim.keymap.set("n", "<leader>ms", "<cmd>LivePreview stop<cr>", { desc = "Stop live preview" })
vim.keymap.set("n", "<leader>mf", "<cmd>LivePreview pick<cr>", { desc = "Pick file to preview" })

-- ── Neotest ────────────────────────────────────
require("neotest").setup({
	adapters = {
		require("neotest-python")({
			dap = { justMyCode = false },
			runner = "pytest",
		}),
		require("neotest-gtest").setup({}),
		require("neotest-zig")({
			dap = { adapter = "codelldb" },
		}),
	},
	status = { virtual_text = true },
	output = { open_on_run = true },
})

vim.keymap.set("n", "<leader>nr", function()
	require("neotest").run.run()
end, { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>nf", function()
	require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Run file tests" })
vim.keymap.set("n", "<leader>nA", function()
	require("neotest").run.run({ suite = true })
end, { desc = "Run all tests" })
vim.keymap.set("n", "<leader>nd", function()
	require("neotest").run.run({ strategy = "dap" })
end, { desc = "Debug nearest test" })
vim.keymap.set("n", "<leader>ns", function()
	require("neotest").run.stop()
end, { desc = "Stop test" })
vim.keymap.set("n", "<leader>nl", function()
	require("neotest").run.run_last()
end, { desc = "Run last test" })
vim.keymap.set("n", "<leader>no", function()
	require("neotest").output.open({ enter = true, auto_close = true })
end, { desc = "Show output" })
vim.keymap.set("n", "<leader>nO", function()
	require("neotest").output_panel.toggle()
end, { desc = "Toggle output panel" })
vim.keymap.set("n", "<leader>nv", function()
	require("neotest").summary.toggle()
end, { desc = "Toggle summary" })

-- ── Kulala (HTTP) ──────────────────────────────
require("kulala").setup({
	default_view = "body",
	default_env = "dev",
})

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

-- ── Just (command runner) ──────────────────────
vim.keymap.set("n", "<leader>jr", function()
	local handle = io.popen("just --summary 2>/dev/null")
	if not handle then
		vim.notify("No justfile found", vim.log.levels.WARN)
		return
	end
	local result = handle:read("*a")
	handle:close()
	if result == "" then
		vim.notify("No justfile found", vim.log.levels.WARN)
		return
	end
	local recipes = vim.split(vim.trim(result), " ")
	vim.ui.select(recipes, { prompt = "Just> " }, function(choice)
		if choice then
			vim.cmd("!" .. "just " .. choice)
		end
	end)
end, { desc = "Just run recipe" })

vim.keymap.set("n", "<leader>jl", function()
	vim.cmd("!just --list")
end, { desc = "Just list recipes" })

vim.keymap.set("n", "<leader>je", function()
	vim.cmd("e justfile")
end, { desc = "Edit justfile" })
