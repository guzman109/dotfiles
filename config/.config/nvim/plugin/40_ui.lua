-- ── 40_ui.lua ──────────────────────────────────
-- Neovim config: Colorscheme and visual enhancements. Loads early so colors are set before first draw.

vim.pack.add({
	"https://github.com/catppuccin/nvim",
	"https://github.com/EdenEast/nightfox.nvim",
	"https://github.com/HiPhish/rainbow-delimiters.nvim",
	"https://github.com/f-person/auto-dark-mode.nvim",
	"https://github.com/lukas-reineke/indent-blankline.nvim",
})

local theme_pairs = {
	catppuccin = {
		light = "catppuccin-latte",
		dark = "catppuccin-mocha",
	},
	nightfox = {
		light = "dawnfox",
		dark = "duskfox",
	},
	carbonfox = {
		light = "dayfox",
		dark = "carbonfox",
	},
}

local default_theme_pair = "nightfox"

vim.g.theme_pair = theme_pairs[vim.g.theme_pair] and vim.g.theme_pair or default_theme_pair
vim.opt.shortmess:append("I")

local function active_theme_name()
	local pair = theme_pairs[vim.g.theme_pair] or theme_pairs.nightfox
	return pair[vim.o.background == "light" and "light" or "dark"]
end

local function hex_to_rgb(hex)
	hex = hex:gsub("#", "")
	return {
		r = tonumber(hex:sub(1, 2), 16) / 255,
		g = tonumber(hex:sub(3, 4), 16) / 255,
		b = tonumber(hex:sub(5, 6), 16) / 255,
	}
end

local function rgb_to_hex(rgb)
	local function ch(x)
		x = math.max(0, math.min(255, math.floor(x * 255 + 0.5)))
		return string.format("%02x", x)
	end
	return "#" .. ch(rgb.r) .. ch(rgb.g) .. ch(rgb.b)
end

local function rgb_to_hsv(rgb)
	local r, g, b = rgb.r, rgb.g, rgb.b
	local maxc = math.max(r, g, b)
	local minc = math.min(r, g, b)
	local delta = maxc - minc

	local h = 0
	if delta ~= 0 then
		if maxc == r then
			h = ((g - b) / delta) % 6
		elseif maxc == g then
			h = ((b - r) / delta) + 2
		else
			h = ((r - g) / delta) + 4
		end
		h = h / 6
	end

	local s = maxc == 0 and 0 or (delta / maxc)
	local v = maxc

	return { h = h, s = s, v = v }
end

local function hsv_to_rgb(hsv)
	local h = (hsv.h % 1) * 6
	local s = math.max(0, math.min(1, hsv.s))
	local v = math.max(0, math.min(1, hsv.v))

	local c = v * s
	local x = c * (1 - math.abs((h % 2) - 1))
	local m = v - c

	local r, g, b = 0, 0, 0
	if h < 1 then
		r, g, b = c, x, 0
	elseif h < 2 then
		r, g, b = x, c, 0
	elseif h < 3 then
		r, g, b = 0, c, x
	elseif h < 4 then
		r, g, b = 0, x, c
	elseif h < 5 then
		r, g, b = x, 0, c
	else
		r, g, b = c, 0, x
	end

	return {
		r = r + m,
		g = g + m,
		b = b + m,
	}
end

local function hex_to_hsv(hex)
	return rgb_to_hsv(hex_to_rgb(hex))
end

local function hsv_to_hex(hsv)
	return rgb_to_hex(hsv_to_rgb(hsv))
end

local function clamp01(x)
	return math.max(0, math.min(1, x))
end

local function hsv_fade_steps(hex, steps)
	local hsv = hex_to_hsv(hex)
	local out = {}

	for _, step in ipairs(steps) do
		out[#out + 1] = hsv_to_hex({
			h = hsv.h,
			s = clamp01(hsv.s * (step.s or 1)),
			v = clamp01(hsv.v * (step.v or 1)),
		})
	end

	return out
end

-- ── Nightfox ───────────────────────────────────
require("nightfox").setup({
	options = {
		transparent = true,
		terminal_colors = true,
		dim_inactive = false,
		styles = {
			comments = "bold,italic",
			keywords = "italic,bold",
			functions = "italic",
			types = "italic,bold",
			operators = "bold",
		},
	},
})

-- ── Catppuccin ─────────────────────────────────
require("catppuccin").setup({
	flavour = "auto",
	background = {
		light = "latte",
		dark = "mocha",
	},
	transparent_background = true,
	show_end_of_buffer = true,
	term_colors = true,
	styles = {
		comments = { "bold", "italic" },
		keywords = { "italic", "bold" },
		functions = { "italic" },
		loops = { "italic" },
		properties = { "bold" },
		types = { "italic", "bold" },
		operators = { "bold" },
	},
	highlight_overrides = {
		all = function(c)
			local float_bg = c.mantle
			local muted_bg = c.crust
			local select_bg = c.surface1
			local accent_fg = c.lavender
			local tabline_fill = c.mantle

			local current_fades = hsv_fade_steps(c.mauve, {
				{ s = 0.95, v = 0.92 },
				{ s = 0.75, v = 0.72 },
				{ s = 0.45, v = 0.45 },
			})

			local hidden_fades = hsv_fade_steps(c.surface1, {
				{ s = 0.95, v = 0.92 },
				{ s = 0.80, v = 0.78 },
				{ s = 0.60, v = 0.62 },
			})

			local harpoon_current_fades = hsv_fade_steps(c.lavender, {
				{ s = 0.95, v = 0.92 },
				{ s = 0.75, v = 0.72 },
				{ s = 0.45, v = 0.45 },
			})

			local harpoon_hidden_fades = hsv_fade_steps(c.blue, {
				{ s = 0.95, v = 0.90 },
				{ s = 0.75, v = 0.70 },
				{ s = 0.45, v = 0.42 },
			})

			return {
				MiniStatuslineFilename = { fg = c.crust, bg = c.blue, bold = true },
				MiniStatuslineFileinfo = { fg = c.text, bg = c.surface0 },
				MiniStatuslineDevinfo = { fg = c.subtext1, bg = c.mantle },
				MiniStatuslineDiff = { fg = c.crust, bg = c.yellow, bold = true },
				MiniStatuslineDiagnostics = { fg = c.crust, bg = c.red, bold = true },
				MiniStatuslineInactive = { fg = c.overlay1, bg = c.mantle },
				MiniStatuslineModeNormal = { fg = c.crust, bg = c.mauve, bold = true },
				MiniStatuslineModeInsert = { fg = c.crust, bg = c.green, bold = true },
				MiniStatuslineModeVisual = { fg = c.crust, bg = c.peach, bold = true },
				MiniStatuslineModeReplace = { fg = c.crust, bg = c.red, bold = true },
				MiniStatuslineModeCommand = { fg = c.crust, bg = c.sapphire, bold = true },
				MiniStatuslineModeOther = { fg = c.crust, bg = c.lavender, bold = true },

				NvimTablineCurrent = { fg = c.crust, bg = c.mauve, bold = true, italic = true },
				NvimTablineCurrentFade1 = { fg = current_fades[1], bg = tabline_fill },
				NvimTablineCurrentFade2 = { fg = current_fades[2], bg = tabline_fill },
				NvimTablineCurrentFade3 = { fg = current_fades[3], bg = tabline_fill },

				NvimTablineHidden = { fg = c.text, bg = c.surface1, bold = true },
				NvimTablineHiddenFade1 = { fg = hidden_fades[1], bg = tabline_fill },
				NvimTablineHiddenFade2 = { fg = hidden_fades[2], bg = tabline_fill },
				NvimTablineHiddenFade3 = { fg = hidden_fades[3], bg = tabline_fill },

				NvimTablineHarpoonCurrent = { fg = c.crust, bg = c.lavender, bold = true, italic = true },
				NvimTablineHarpoonCurrentFade1 = { fg = harpoon_current_fades[1], bg = tabline_fill },
				NvimTablineHarpoonCurrentFade2 = { fg = harpoon_current_fades[2], bg = tabline_fill },
				NvimTablineHarpoonCurrentFade3 = { fg = harpoon_current_fades[3], bg = tabline_fill },

				NvimTablineHarpoonHidden = { fg = c.crust, bg = c.blue, bold = true },
				NvimTablineHarpoonHiddenFade1 = { fg = harpoon_hidden_fades[1], bg = tabline_fill },
				NvimTablineHarpoonHiddenFade2 = { fg = harpoon_hidden_fades[2], bg = tabline_fill },
				NvimTablineHarpoonHiddenFade3 = { fg = harpoon_hidden_fades[3], bg = tabline_fill },

				NvimTablineFill = { fg = c.overlay0, bg = tabline_fill },
				NvimTablineSection = { fg = c.crust, bg = c.subtext0, bold = true },

				CursorLine = { bg = c.surface0 },
				CursorLineNr = { fg = c.peach, bg = c.surface0, bold = true },
				Visual = { bg = c.surface1 },
				NormalFloat = { fg = c.text, bg = float_bg },
				FloatBorder = { fg = c.surface2, bg = float_bg },
				FloatTitle = { fg = accent_fg, bg = float_bg, bold = true },
				Pmenu = { fg = c.text, bg = float_bg },
				PmenuSel = { fg = c.text, bg = select_bg },
				PmenuSbar = { bg = muted_bg },
				PmenuThumb = { bg = c.overlay0 },
				FzfLuaNormal = { fg = c.text, bg = float_bg },
				FzfLuaBorder = { fg = c.surface2, bg = float_bg },
				FzfLuaTitle = { fg = accent_fg, bg = float_bg, bold = true },
				FzfLuaBackdrop = { bg = muted_bg, blend = 90 },
				FzfLuaCursorLine = { bg = c.surface0 },
				FzfLuaPreviewNormal = { fg = c.text, bg = float_bg },
				FzfLuaPreviewBorder = { fg = c.surface2, bg = float_bg },
				FzfLuaPreviewTitle = { fg = accent_fg, bg = float_bg, bold = true },
				FzfLuaFzfNormal = { fg = c.text, bg = float_bg },
				FzfLuaFzfBorder = { fg = c.surface2, bg = float_bg },
				FzfLuaFzfGutter = { bg = float_bg },
				FzfLuaFzfCursorLine = { fg = c.text, bg = select_bg },
				FzfLuaFzfPointer = { fg = c.mauve, bg = select_bg, bold = true },
				FzfLuaFzfMarker = { fg = c.red, bg = select_bg, bold = true },
				FzfLuaFzfPrompt = { fg = accent_fg, bg = float_bg, bold = true },
				FzfLuaFzfQuery = { fg = c.text, bg = float_bg },
				FzfLuaFzfInfo = { fg = c.overlay1, bg = float_bg },
				FzfLuaFzfHeader = { fg = c.subtext1, bg = float_bg },
				FzfLuaFzfMatch = { fg = c.lavender, bg = select_bg, bold = true },
			}
		end,
	},
})

local function apply_catppuccin_popup_highlights()
	local colorscheme = vim.g.colors_name or ""
	local flavour = colorscheme:match("latte") and "latte" or "mocha"
	local c = require("catppuccin.palettes").get_palette(flavour)
	local float_bg = c.mantle
	local muted_bg = c.crust
	local select_bg = c.surface1
	local accent_fg = c.lavender

	local highlights = {
		CursorLine = { bg = c.surface0 },
		CursorLineNr = { fg = c.peach, bg = c.surface0, bold = true },
		Visual = { bg = c.surface1 },
		NormalFloat = { fg = c.text, bg = float_bg },
		FloatBorder = { fg = c.surface2, bg = float_bg },
		FloatTitle = { fg = accent_fg, bg = float_bg, bold = true },
		Pmenu = { fg = c.text, bg = float_bg },
		PmenuSel = { fg = c.text, bg = select_bg },
		PmenuSbar = { bg = muted_bg },
		PmenuThumb = { bg = c.overlay0 },
		FzfLuaNormal = { fg = c.text, bg = float_bg },
		FzfLuaBorder = { fg = c.surface2, bg = float_bg },
		FzfLuaTitle = { fg = accent_fg, bg = float_bg, bold = true },
		FzfLuaBackdrop = { bg = muted_bg, blend = 90 },
		FzfLuaCursorLine = { bg = c.surface0 },
		FzfLuaPreviewNormal = { fg = c.text, bg = float_bg },
		FzfLuaPreviewBorder = { fg = c.surface2, bg = float_bg },
		FzfLuaPreviewTitle = { fg = accent_fg, bg = float_bg, bold = true },
		FzfLuaFzfNormal = { fg = c.text, bg = float_bg },
		FzfLuaFzfBorder = { fg = c.surface2, bg = float_bg },
		FzfLuaFzfGutter = { bg = float_bg },
		FzfLuaFzfCursorLine = { fg = c.text, bg = select_bg },
		FzfLuaFzfPointer = { fg = c.mauve, bg = select_bg, bold = true },
		FzfLuaFzfMarker = { fg = c.red, bg = select_bg, bold = true },
		FzfLuaFzfPrompt = { fg = accent_fg, bg = float_bg, bold = true },
		FzfLuaFzfQuery = { fg = c.text, bg = float_bg },
		FzfLuaFzfInfo = { fg = c.overlay1, bg = float_bg },
		FzfLuaFzfHeader = { fg = c.subtext1, bg = float_bg },
		FzfLuaFzfMatch = { fg = c.lavender, bg = select_bg, bold = true },
	}

	for group, spec in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, spec)
	end
end

local apply_nightfox_popup_highlights

local function apply_popup_highlights()
	if vim.g.colors_name and vim.g.colors_name:match("catppuccin") then
		apply_catppuccin_popup_highlights()
		return
	end
	if vim.g.colors_name and vim.g.colors_name:match("fox$") then
		apply_nightfox_popup_highlights()
	end
end

local function apply_active_theme()
	vim.cmd.colorscheme(active_theme_name())
	apply_popup_highlights()
end

local function persist_theme_pair(theme_pair)
	local config_file = vim.fn.stdpath("config") .. "/plugin/40_ui.lua"
	local lines = vim.fn.readfile(config_file)
	for i, line in ipairs(lines) do
		if line:match('^local default_theme_pair = ".+"$') then
			lines[i] = string.format('local default_theme_pair = "%s"', theme_pair)
			vim.fn.writefile(lines, config_file)
			return true
		end
	end
	return false
end

apply_nightfox_popup_highlights = function()
	local p = require("nightfox.palette").load(vim.g.colors_name)
	local bg = p.bg1
	local sel = p.sel0

	local function nf_color(value)
		if type(value) == "table" then
			return value.base or value.bright or value.dim
		end
		return value
	end

	local current_fades = hsv_fade_steps(nf_color(p.magenta), {
		{ s = 0.95, v = 0.92 },
		{ s = 0.75, v = 0.72 },
		{ s = 0.45, v = 0.45 },
	})

	local hidden_fades = hsv_fade_steps(p.bg3, {
		{ s = 0.95, v = 0.92 },
		{ s = 0.80, v = 0.78 },
		{ s = 0.60, v = 0.62 },
	})

	local harpoon_current_fades = hsv_fade_steps(nf_color(p.blue), {
		{ s = 0.95, v = 0.92 },
		{ s = 0.75, v = 0.72 },
		{ s = 0.45, v = 0.45 },
	})

	local harpoon_hidden_fades = hsv_fade_steps(nf_color(p.cyan), {
		{ s = 0.95, v = 0.90 },
		{ s = 0.75, v = 0.70 },
		{ s = 0.45, v = 0.42 },
	})

	local highlights = {
		CursorLine = { bg = p.bg3 },
		CursorLineNr = { fg = nf_color(p.orange), bg = p.bg3, bold = true },
		Visual = { bg = sel },

		NvimTablineCurrent = { fg = p.bg0, bg = nf_color(p.magenta), bold = true, italic = true },
		NvimTablineCurrentFade1 = { fg = current_fades[1], bg = p.bg0 },
		NvimTablineCurrentFade2 = { fg = current_fades[2], bg = p.bg0 },
		NvimTablineCurrentFade3 = { fg = current_fades[3], bg = p.bg0 },

		NvimTablineHidden = { fg = p.fg2, bg = p.bg3, bold = true },
		NvimTablineHiddenFade1 = { fg = hidden_fades[1], bg = p.bg0 },
		NvimTablineHiddenFade2 = { fg = hidden_fades[2], bg = p.bg0 },
		NvimTablineHiddenFade3 = { fg = hidden_fades[3], bg = p.bg0 },

		NvimTablineHarpoonCurrent = { fg = p.bg0, bg = nf_color(p.blue), bold = true, italic = true },
		NvimTablineHarpoonCurrentFade1 = { fg = harpoon_current_fades[1], bg = p.bg0 },
		NvimTablineHarpoonCurrentFade2 = { fg = harpoon_current_fades[2], bg = p.bg0 },
		NvimTablineHarpoonCurrentFade3 = { fg = harpoon_current_fades[3], bg = p.bg0 },

		NvimTablineHarpoonHidden = { fg = p.bg0, bg = nf_color(p.cyan), bold = true },
		NvimTablineHarpoonHiddenFade1 = { fg = harpoon_hidden_fades[1], bg = p.bg0 },
		NvimTablineHarpoonHiddenFade2 = { fg = harpoon_hidden_fades[2], bg = p.bg0 },
		NvimTablineHarpoonHiddenFade3 = { fg = harpoon_hidden_fades[3], bg = p.bg0 },

		NvimTablineFill = { fg = p.comment, bg = p.bg0 },
		NvimTablineSection = { fg = p.bg0, bg = p.bg4, bold = true },

		NormalFloat = { fg = p.fg1, bg = bg },
		FloatBorder = { fg = p.comment, bg = bg },
		FloatTitle = { fg = nf_color(p.cyan), bg = bg, bold = true },
		Pmenu = { fg = p.fg1, bg = bg },
		PmenuSel = { fg = p.fg1, bg = sel },
		PmenuSbar = { bg = p.bg4 },
		PmenuThumb = { bg = p.comment },
		FzfLuaNormal = { fg = p.fg1, bg = bg },
		FzfLuaBorder = { fg = p.comment, bg = bg },
		FzfLuaTitle = { fg = nf_color(p.cyan), bg = bg, bold = true },
		FzfLuaBackdrop = { bg = p.bg0, blend = 90 },
		FzfLuaCursorLine = { bg = p.bg3 },
		FzfLuaPreviewNormal = { fg = p.fg1, bg = bg },
		FzfLuaPreviewBorder = { fg = p.comment, bg = bg },
		FzfLuaPreviewTitle = { fg = nf_color(p.cyan), bg = bg, bold = true },
		FzfLuaFzfNormal = { fg = p.fg1, bg = bg },
		FzfLuaFzfBorder = { fg = p.comment, bg = bg },
		FzfLuaFzfGutter = { bg = bg },
		FzfLuaFzfCursorLine = { fg = p.fg1, bg = sel },
		FzfLuaFzfPointer = { fg = nf_color(p.magenta), bg = sel, bold = true },
		FzfLuaFzfMarker = { fg = nf_color(p.red), bg = sel, bold = true },
		FzfLuaFzfPrompt = { fg = nf_color(p.cyan), bg = bg, bold = true },
		FzfLuaFzfQuery = { fg = p.fg1, bg = bg },
		FzfLuaFzfInfo = { fg = p.comment, bg = bg },
		FzfLuaFzfHeader = { fg = p.fg3, bg = bg },
		FzfLuaFzfMatch = { fg = nf_color(p.blue), bg = sel, bold = true },
	}

	for group, spec in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, spec)
	end
end

apply_active_theme()

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("NvimConfigThemePopupHighlights", { clear = true }),
	pattern = { "catppuccin*", "*fox" },
	callback = apply_popup_highlights,
})

vim.api.nvim_create_user_command("ThemePair", function(opts)
	if not theme_pairs[opts.args] then
		vim.notify("Unknown theme pair: " .. opts.args, vim.log.levels.ERROR)
		return
	end
	vim.g.theme_pair = opts.args
	if not persist_theme_pair(opts.args) then
		vim.notify("Failed to persist default theme pair in plugin/40_ui.lua", vim.log.levels.WARN)
	end
	apply_active_theme()
end, {
	nargs = 1,
	complete = function()
		return vim.tbl_keys(theme_pairs)
	end,
})

vim.o.showtabline = 2
vim.o.tabline = "%!v:lua.require'tabline'.render()"

-- ── Auto Dark Mode ─────────────────────────────
require("auto-dark-mode").setup({
	update_interval = 1000,
	set_dark_mode = function()
		vim.api.nvim_set_option_value("background", "dark", {})
		apply_active_theme()
	end,
	set_light_mode = function()
		vim.api.nvim_set_option_value("background", "light", {})
		apply_active_theme()
	end,
})

-- ── Indent Guides ──────────────────────────────
require("ibl").setup({
	indent = {
		char = "│",
		tab_char = "│",
	},
	scope = { enabled = false },
	exclude = {
		filetypes = { "help", "alpha", "mason", "checkhealth", "ministarter" },
	},
})

local function get_quote()
	local ok, quote = pcall(vim.fn.system, "fish ~/.config/inspiration/quote-cache.fish --type motivation --box 58")
	if ok and vim.v.shell_error == 0 then
		return quote:gsub("\n$", "")
	end
	return ""
end

local function clean_plugins()
	local unused = vim.iter(vim.pack.get())
		:filter(function(x)
			return not x.active
		end)
		:map(function(x)
			return x.spec.name
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

-- ── Mini.starter (dashboard) ──────────────────
local starter = require("mini.starter")

local function build_header()
	local logo = {
		"███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
		"████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
		"██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
		"██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
		"██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
		"╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
	}
	local version = vim.version()
	local rule = string.rep("─", 58)

	local header_lines = {
		"",
		"",
		"",
		"v" .. version.major .. "." .. version.minor .. "." .. version.patch,
		"",
		get_quote(),
		"",
		os.date("%A, %B %d, %Y"),
		rule,
	}

	for i = #logo, 1, -1 do
		table.insert(header_lines, 5, logo[i])
	end

	return table.concat(header_lines, "\n")
end

starter.setup({
	header = build_header,
	items = {
		{
			name = "f  Find files",
			action = function()
				require("fzf-lua").files()
			end,
			section = "Files",
		},
		{
			name = "g  Live grep",
			action = function()
				require("fzf-lua").live_grep()
			end,
			section = "Files",
		},
		{
			name = "t  TODOs",
			action = function()
				require("fzf-lua").grep({ search = "TODO|FIXME|HACK|NOTE|WARN" })
			end,
			section = "Files",
		},
		{ name = "e  Edit config", action = "e " .. vim.fn.stdpath("config") .. "/init.lua", section = "Config" },
		{ name = "k  Keymaps", action = "e " .. vim.fn.stdpath("config") .. "/KEYMAPS.md", section = "Config" },
		{ name = "c  Commands", action = "e " .. vim.fn.stdpath("config") .. "/COMMANDS.md", section = "Config" },
		{ name = "u  Update plugins", action = "lua vim.pack.update()", section = "Core" },
		{ name = "x  Clean plugins", action = clean_plugins, section = "Core" },
		{ name = "r  Restart", action = "restart", section = "Core" },
		{ name = "q  Quit", action = "qa", section = "Core" },
	},
	content_hooks = {
		starter.gen_hook.aligning("center", "center"),
	},
	footer = "",
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("NvimConfigStarter", { clear = true }),
	pattern = "ministarter",
	callback = function()
		vim.opt_local.foldenable = false
		vim.opt_local.wrap = false
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
		vim.opt_local.statuscolumn = ""
		vim.opt_local.foldcolumn = "0"
		vim.opt_local.cursorline = false
		vim.opt_local.list = false
	end,
})
