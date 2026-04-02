-- ── 30_mini.lua ────────────────────────────────
-- ClaudlosVim: mini.nvim modules.

vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

-- Surround editing (sa = add, sd = delete, sr = replace)
require("mini.surround").setup()

-- Auto-close brackets and quotes
require("mini.pairs").setup()

-- File icons (used by fzf-lua, markview, etc.)
require("mini.icons").setup({
	extension = {
		hpp = { glyph = "󰫵", hl = "MiniIconsBlue" },
	},
	file = {
		["conanfile.py"] = { glyph = "󰆦", hl = "MiniIconsBlue" },
		["conanfile.txt"] = { glyph = "󰆦", hl = "MiniIconsBlue" },
	},
	filetype = {
		meson = { glyph = "󰰐", hl = "MiniIconsPurple" },
		cpp = { glyph = "", hl = "MiniIconsBlue" },
	},
})

-- ── Clue (keymap hints) ───────────────────────
local miniclue = require("mini.clue")
miniclue.setup({
	triggers = {
		{ mode = "n", keys = "<Leader>" },
		{ mode = "x", keys = "<Leader>" },
		{ mode = "v", keys = "<Leader>" },

		{ mode = "n", keys = "g" },
		{ mode = "x", keys = "g" },
		{ mode = "n", keys = "'" },
		{ mode = "x", keys = "'" },
		{ mode = "n", keys = "`" },
		{ mode = "x", keys = "`" },
		{ mode = "n", keys = '"' },
		{ mode = "x", keys = '"' },
		{ mode = "i", keys = "<C-r>" },
		{ mode = "c", keys = "<C-r>" },

		{ mode = "n", keys = "<C-w>" },

		{ mode = "n", keys = "z" },
		{ mode = "x", keys = "z" },

		{ mode = "n", keys = "[" },
		{ mode = "n", keys = "]" },
	},

	clues = {
		miniclue.gen_clues.builtin_completion(),
		miniclue.gen_clues.g(),
		miniclue.gen_clues.marks(),
		miniclue.gen_clues.registers(),
		miniclue.gen_clues.windows(),
		miniclue.gen_clues.z(),

		{ mode = "n", keys = "<Leader>f", desc = "+find" },
		{ mode = "n", keys = "<Leader>g", desc = "+git" },
		{ mode = "n", keys = "<Leader>c", desc = "+code" },
		{ mode = "n", keys = "<Leader>d", desc = "+debug" },
		{ mode = "n", keys = "<Leader>n", desc = "+test" },
		{ mode = "n", keys = "<Leader>t", desc = "+tab/terminal" },
		{ mode = "n", keys = "<Leader>p", desc = "+python" },
		{ mode = "n", keys = "<Leader>z", desc = "+zig" },
		{ mode = "n", keys = "<Leader>h", desc = "+harpoon" },
		{ mode = "n", keys = "<Leader>k", desc = "+kulala" },
		{ mode = "n", keys = "<Leader>a", desc = "+ai" },
		{ mode = "n", keys = "<Leader>l", desc = "+lua" },
		{ mode = "n", keys = "<Leader>m", desc = "+preview" },
		{ mode = "n", keys = "<Leader>w", desc = "+window" },
		{ mode = "v", keys = "<Leader>a", desc = "+ai" },
		{ mode = "n", keys = "<Leader>j", desc = "+just" },
	},

	window = {
		delay = 300,
		config = {
			width = "auto",
		},
	},
})

-- Animate
require("mini.animate").setup({
	scroll = { enable = false },
})

-- Hipatters
require("mini.hipatterns").setup({
	highlighters = {
		fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
		hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
		todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
		note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
	},
})
