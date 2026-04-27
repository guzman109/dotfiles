-- ── 30_mini.lua ────────────────────────────────
-- Neovim config: mini.nvim modules.

vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.nvim", name = "mini.nvim" },
	{ src = "https://github.com/folke/which-key.nvim", name = "which-key" },
})

require("mini.icons").setup({
	file = {
		["conanfile.py"] = { glyph = "󰆦", hl = "MiniIconsBlue" },
		["conanfile.txt"] = { glyph = "󰆦", hl = "MiniIconsBlue" },
	},
	extension = {
		cmake = { glyph = "󰔷", hl = "MiniIconsBlue" },
		hpp = { glyph = "󰫵", hl = "MiniIconsPurple" },
	},
	filetype = {
		cmake = { glyph = "󰔷", hl = "MiniIconsBlue" },
	},
})
MiniIcons.mock_nvim_web_devicons()
require("mini.notify").setup()
require("mini.cmdline").setup({
	autocomplete = {
		enable = false,
	},
	autocorrect = {
		enable = false,
	},
})
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
require("mini.move").setup({
	mappings = {
		left = "<A-h>",
		right = "<A-l>",
		down = "<A-j>",
		up = "<A-k>",
		line_left = "<A-h>",
		line_right = "<A-l>",
		line_down = "<A-j>",
		line_up = "<A-k>",
	},
})
require("mini.trailspace").setup()
require("mini.indentscope").setup({
	draw = {
		animation = require("mini.indentscope").gen_animation.none(),
	},
})
-- ── Kitty tabs indicator ──────────────────────
-- Async-refreshes the output of ~/.config/starship/kitty-tabs.sh and exposes it
-- as `kitty_tabs_text` for the statusline. Cached so the statusline never shells out.
local kitty_tabs_text = ""
local kitty_tabs_script = vim.fn.expand("~/.config/starship/kitty-tabs.sh")

local function refresh_kitty_tabs()
	if (vim.env.KITTY_WINDOW_ID or "") == "" then
		return
	end
	if vim.fn.executable(kitty_tabs_script) == 0 then
		return
	end
	vim.system({ kitty_tabs_script }, { text = true }, function(obj)
		if obj.code ~= 0 then
			return
		end
		local text = vim.trim(obj.stdout or "")
		if text ~= kitty_tabs_text then
			kitty_tabs_text = text
			vim.schedule(function()
				vim.cmd("redrawstatus")
			end)
		end
	end)
end

vim.api.nvim_create_autocmd({ "VimEnter", "FocusGained" }, {
	group = vim.api.nvim_create_augroup("NvimConfigKittyTabs", { clear = true }),
	callback = refresh_kitty_tabs,
})

local kitty_tabs_timer = vim.uv.new_timer()
if kitty_tabs_timer then
	kitty_tabs_timer:start(500, 5000, vim.schedule_wrap(refresh_kitty_tabs))
end

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
			local kitty_tabs = MiniStatusline.is_truncated(75) and "" or kitty_tabs_text
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
				{ hl = mode_hl, strings = { kitty_tabs, datetime } },
			})
		end,
	},
})

-- Surround editing (sa = add, sd = delete, sr = replace)
require("mini.surround").setup()

-- Auto-close brackets and quotes
require("mini.pairs").setup()

-- ── Which Key (keymap hints) ───────────────────
local wk = require("which-key")
wk.setup({
	preset = "modern",
	delay = 150,
	disable = {
		bt = { "terminal" },
	},
})
wk.add({
	{ "<leader>N", group = "nvim" },
	{ "<leader>a", group = "ai" },
	{ "<leader>c", group = "code" },
	{ "<leader>d", group = "debug" },
	{ "<leader>f", group = "find" },
	{ "<leader>g", group = "git" },
	{ "<leader>h", group = "harpoon" },
	{ "<leader>j", group = "jump" },
	{ "<leader>k", group = "kulala" },
	{ "<leader>m", group = "preview" },
	{ "<leader>p", group = "project" },
	{ "<leader>t", group = "tab/terminal" },
	{ "<leader>w", group = "window" },
	{ "<leader>x", group = "trouble" },
	{ "<leader>a", group = "ai", mode = "v" },
	{ "<leader>f", group = "find", mode = "v" },
})

-- Animate
require("mini.animate").setup({
	scroll = { enable = false },
})

	vim.api.nvim_create_autocmd("TextYankPost", {
		group = vim.api.nvim_create_augroup("NvimConfigMiniYank", { clear = true }),
		callback = function()
			vim.hl.on_yank({ higroup = "IncSearch", timeout = 120 })
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
