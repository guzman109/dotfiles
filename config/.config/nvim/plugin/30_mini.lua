-- ── 30_mini.lua ────────────────────────────────
-- Neovim config: mini.nvim modules.

vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

require("mini.icons").setup({
	file = {
		["conanfile.py"] = { glyph = "󰆦", hl = "MiniIconsBlue" },
		["conanfile.txt"] = { glyph = "󰆦", hl = "MiniIconsBlue" },
	},
	extension = {
		hpp = { glyph = "󰫵", hl = "MiniIconsBlue" },
	},
	filetype = {
		meson = { glyph = "󰔷", hl = "MiniIconsBlue" },
	},
})
MiniIcons.mock_nvim_web_devicons()
require("mini.notify").setup()
require("mini.cmdline").setup()
require("mini.cursorword").setup()
require("mini.jump").setup({ silent = true })
require("mini.jump2d").setup({
	mappings = {
		start_jumping = "",
	},
	silent = true,
	view = {
		dim = true,
		n_steps_ahead = 1,
	},
})
require("mini.splitjoin").setup()
require("mini.trailspace").setup()
require("mini.indentscope").setup({
	draw = {
		animation = require("mini.indentscope").gen_animation.none(),
	},
})
require("mini.files").setup({
	options = {
		use_as_default_explorer = true,
	},
	windows = {
		preview = true,
		width_focus = 36,
		width_nofocus = 18,
		width_preview = 48,
	},
})

require("mini.statusline").setup({
	use_icons = true,
	content = {
		active = function()
			local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
			local git = MiniStatusline.section_git({ trunc_width = 40 })
			local diff = MiniStatusline.section_diff({ trunc_width = 75 })
			local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
			local filename = MiniStatusline.section_filename({ trunc_width = 140 })
			local progress = MiniStatusline.is_truncated(100) and "" or "%P"
			local encoding = MiniStatusline.is_truncated(120) and ""
				or (vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding)
			local datetime = MiniStatusline.is_truncated(140) and "" or os.date("%a %b %d %I:%M %p")
			local row, col = unpack(vim.api.nvim_win_get_cursor(0))
			local raw_search = MiniStatusline.section_searchcount({ trunc_width = 75 })
			local location = MiniStatusline.is_truncated(75) and "" or string.format("Row %d Col %d", row, col)
			local search = raw_search ~= "" and ("Search " .. raw_search) or ""
			local icon = ""
			if _G.MiniIcons then
				local path = vim.api.nvim_buf_get_name(0)
				local icon_text = select(1, MiniIcons.get("file", path ~= "" and path or filename))
				if icon_text and icon_text ~= "" then
					icon = icon_text .. " "
				end
			end
			local file_label = icon ~= "" and (icon .. filename) or filename

			return MiniStatusline.combine_groups({
				{ hl = mode_hl, strings = { mode } },
				"%<",
				{ hl = "MiniStatuslineDevinfo", strings = { git } },
				{ hl = "MiniStatuslineDevinfo", strings = { file_label } },
				"%=",
				{ hl = "MiniStatuslineDevinfo", strings = { diff } },
				{ hl = "MiniStatuslineDevinfo", strings = { diagnostics } },
				{ hl = "MiniStatuslineDevinfo", strings = { search, progress, location } },
				-- { hl = "MiniStatuslineFileinfo", strings = { search, progress, encoding } },
				{ hl = mode_hl, strings = { datetime } },
			})
		end,
	},
})

-- Surround editing (sa = add, sd = delete, sr = replace)
require("mini.surround").setup()

-- Auto-close brackets and quotes
require("mini.pairs").setup()

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

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("NvimConfigMiniYank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 120 })
	end,
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

-- Diff
require("mini.diff").setup()

--
