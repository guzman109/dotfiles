-- ── 50_editor.lua ──────────────────────────────
-- ClaudlosVim: Editor plugins — finder, git, navigation, formatting, testing, commands.

vim.pack.add({
	-- Finder
	"https://github.com/ibhagwan/fzf-lua",

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

	-- Command runner (uses harpoon2 for persistence)
	"https://github.com/samharju/yeet.nvim",

	-- Formatting
	"https://github.com/stevearc/conform.nvim",

	-- Treesitter
	"https://github.com/nvim-treesitter/nvim-treesitter",

	-- Markdown rendering
	"https://github.com/OXY2DEV/markview.nvim",

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
})

-- ── fzf-lua ────────────────────────────────────
require("fzf-lua").setup({
	"default-title",
	winopts = {
		height = 0.85,
		width = 0.80,
		row = 0.35,
		scrollbar = false,
	},
	files = {
		cwd_prompt = false,
		hidden = false,
	},
	grep = {
		rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
	},
	previewers = {
		builtin = {
			extensions = {
				["png"] = { "chafa", "{file}" },
				["jpg"] = { "chafa", "{file}" },
				["jpeg"] = { "chafa", "{file}" },
				["gif"] = { "chafa", "{file}" },
				["webp"] = { "chafa", "{file}" },
				["svg"] = { "chafa", "{file}" },
			},
		},
	},
})

-- File browsing (replaces oil)
vim.keymap.set("n", "-", function()
	require("fzf-lua").files({ cwd = vim.fn.expand("%:p:h") })
end, { desc = "Browse parent directory" })
vim.keymap.set("n", "<leader>e", function()
	require("fzf-lua").files({ cwd = vim.fn.expand("%:p:h") })
end, { desc = "File explorer" })

vim.keymap.set("n", "<leader><space>", function()
	require("fzf-lua").files()
end, { desc = "Find files" })
vim.keymap.set("n", "ff", function()
	require("fzf-lua").files()
end, { desc = "Find files" })
vim.keymap.set("n", "<leader>/", function()
	require("fzf-lua").live_grep()
end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", function()
	require("fzf-lua").buffers()
end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", function()
	require("fzf-lua").help_tags()
end, { desc = "Help" })
vim.keymap.set("n", "<leader>fr", function()
	require("fzf-lua").oldfiles()
end, { desc = "Recent files" })
vim.keymap.set("n", "<leader>fd", function()
	require("fzf-lua").diagnostics_document()
end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>fs", function()
	require("fzf-lua").lsp_document_symbols()
end, { desc = "Symbols" })

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

-- ── Harpoon + Yeet ─────────────────────────────
local harpoon = require("harpoon")
harpoon:setup({
	settings = {
		save_on_toggle = false,
		sync_on_ui_close = false,
	},
	-- Yeet command list — stored per-project by harpoon
	yeet = {
		select = function(list_item, _, _)
			require("yeet").execute(list_item.value)
		end,
	},
})

require("yeet").setup({})

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
	harpoon:list():remove()
end, { desc = "Harpoon remove current" })
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
	local files = {}
	for _, item in ipairs(items) do
		table.insert(files, item.value)
	end
	require("fzf-lua").fzf_exec(files, {
		prompt = "Harpoon> ",
		actions = {
			["default"] = require("fzf-lua.actions").file_edit,
		},
	})
end, { desc = "Harpoon menu" })

-- Yeet command list (stored per-project via harpoon)
vim.keymap.set("n", "<leader>yy", function()
	require("yeet").execute()
end, { desc = "Yeet (repeat last)" })

vim.keymap.set("n", "<leader>yl", function()
	harpoon.ui:toggle_quick_menu(harpoon:list("yeet"))
end, { desc = "Yeet command list" })

vim.keymap.set("n", "<leader>yn", function()
	require("yeet").list_cmd()
end, { desc = "Yeet new command" })

vim.keymap.set("n", "<leader>yt", function()
	require("yeet").select_target()
end, { desc = "Yeet select target" })

vim.keymap.set("n", "<leader>yq", function()
	require("yeet").execute(nil, { clear_before_yeet = false, interrupt_before_yeet = true })
end, { desc = "Yeet interrupt & run" })

-- ── Conform ────────────────────────────────────
require("conform").setup({
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		c = { "clang_format" },
		cpp = { "clang_format" },
		fish = { "fish_indent" },
		javascript = { "biome" },
		javascriptreact = { "biome" },
		json = { "biome" },
		jsonc = { "biome" },
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
	},
})

-- ── Treesitter ─────────────────────────────────
require("nvim-treesitter").setup({
	ensure_installed = {
		"bash",
		"c",
		"cpp",
		"fish",
		"javascript",
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
	},
})

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
