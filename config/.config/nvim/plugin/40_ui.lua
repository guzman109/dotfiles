-- ── 40_ui.lua ──────────────────────────────────
-- ClaudlosVim: Colorscheme and visual enhancements.
-- Loads early (02 prefix) so colors are set before first draw.

vim.pack.add({
	"https://github.com/catppuccin/nvim",
	"https://github.com/HiPhish/rainbow-delimiters.nvim",
	"https://github.com/f-person/auto-dark-mode.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/lukas-reineke/indent-blankline.nvim",
	"https://github.com/nanozuki/tabby.nvim",
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
	integrations = {
		aerial = true,
		blink_cmp = true,
		dap = true,
		dap_ui = true,
		gitsigns = true,
		harpoon = true,
		indent_blankline = { enabled = true },
		mason = true,
		markview = true,
		mini = { enabled = true },
		rainbow_delimiters = true,
		ufo = true,
		native_lsp = {
			enabled = true,
			underlines = {
				errors = { "undercurl" },
				hints = { "undercurl" },
				warnings = { "undercurl" },
				information = { "undercurl" },
			},
		},
	},
})

vim.cmd.colorscheme("catppuccin")

-- ── Auto Dark Mode ─────────────────────────────
require("auto-dark-mode").setup({
	update_interval = 1000,
	set_dark_mode = function()
		vim.api.nvim_set_option_value("background", "dark", {})
		vim.cmd.colorscheme("catppuccin-mocha")
		package.loaded["tabby_cfg"] = nil
		vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
		require("tabby").setup({ tabline = require("tabby_cfg") })
	end,
	set_light_mode = function()
		vim.api.nvim_set_option_value("background", "light", {})
		vim.cmd.colorscheme("catppuccin-latte")
		package.loaded["tabby_cfg"] = nil
		vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
		require("tabby").setup({ tabline = require("tabby_cfg") })
	end,
})

-- ── Lualine ────────────────────────────────────
local function datetime()
	local CTimeLine = require("lualine.component"):extend()
	CTimeLine.init = function(self, options)
		CTimeLine.super.init(self, options)
	end
	CTimeLine.update_status = function(self)
		return os.date(self.options.format or "%a %b %d %I:%M %p", os.time())
	end
	return CTimeLine
end

require("lualine").setup({
	options = {
		theme = "auto",
		component_separators = "",
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { { "filename", path = 1 } },
		lualine_x = { "encoding", "filetype" },
		lualine_y = { "progress", "location" },
		lualine_z = {
			{ datetime(), separator = { right = "" }, left_padding = 2 },
		},
	},
})

-- ── Indent Guides ──────────────────────────────
require("ibl").setup({
	indent = {
		char = "│",
		tab_char = "│",
	},
	scope = { enabled = false },
	exclude = {
		filetypes = { "help", "alpha", "mason", "checkhealth" },
	},
})

-- ── Tabby (tabline) ───────────────────────────
require("tabby").setup({
	tabline = require("tabby_cfg"),
})

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("ClaudlosTabby", { clear = true }),
	callback = function()
		require("tabby").setup({
			tabline = require("tabby_cfg"),
		})
	end,
})
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
vim.api.nvim_set_hl(0, "TabLine", { bg = "NONE" })

-- ── Mini.starter (dashboard) ──────────────────
local starter = require("mini.starter")

local function get_quote()
	local ok, quote = pcall(vim.fn.system, "fish ~/.config/inspiration/quote-cache.fish --type motivation --box 58")
	if ok and vim.v.shell_error == 0 then
		-- strip trailing newline
		return quote:gsub("\n$", "")
	end
	return ""
end

local function get_greeting()
	local hour = tonumber(os.date("%H"))
	local greetings = {
		morning = {
			"Good morning, Carlos.",
			"Rise and grind, Carlos.",
			"Early bird, Carlos.",
			"Morning, Carlos. Let's build something.",
			"Coffee first, code second. Morning, Carlos.",
		},
		afternoon = {
			"Carlos returns.",
			"Back at it, Carlos.",
			"Welcome back, Carlos.",
			"Afternoon, Carlos. What are we breaking today?",
			"Carlos is in the building.",
		},
		evening = {
			"Late night session, Carlos?",
			"The grind never stops. Evening, Carlos.",
			"Carlos after dark.",
			"Still going, Carlos?",
			"Evening, Carlos. One more feature.",
		},
	}
	local pool
	if hour >= 5 and hour < 12 then
		pool = greetings.morning
	elseif hour >= 12 and hour < 18 then
		pool = greetings.afternoon
	else
		pool = greetings.evening
	end
	math.randomseed(os.time())
	return pool[math.random(#pool)]
end

local function build_header()
	return table.concat({
		"",
		"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
		"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
		"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
		"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
		"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
		"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
		"",
		"   " .. os.date("%A, %B %d, %Y"),
		"   " .. get_greeting(),
		"",
		get_quote(),
	}, "\n")
end

starter.setup({
	header = build_header,
	items = {
		-- Files
		{ name = "f  Find files",   action = "FzfLua files",    section = "Files" },
		{ name = "g  Live grep",    action = "FzfLua live_grep", section = "Files" },
		{ name = "r  Recent files", action = "FzfLua oldfiles",  section = "Files" },
		{ name = "t  TODOs", action = function()
			require("fzf-lua").grep({ search = "TODO|FIXME|HACK|NOTE|WARN" })
		end, section = "Files" },
		-- Config
		{ name = "e  Edit config", action = "e " .. vim.fn.stdpath("config") .. "/init.lua",    section = "Config" },
		{ name = "k  Keymaps",     action = "e " .. vim.fn.stdpath("config") .. "/KEYMAPS.md",  section = "Config" },
		{ name = "c  Commands",    action = "e " .. vim.fn.stdpath("config") .. "/COMMANDS.md", section = "Config" },
		-- Plugins
		{ name = "u  Update plugins", action = "lua vim.pack.update()", section = "Plugins" },
		{ name = "x  Clean plugins", action = function()
			local unused = vim.iter(vim.pack.get())
				:filter(function(x) return not x.active end)
				:map(function(x) return x.spec.name end)
				:totable()
			if #unused == 0 then
				vim.notify("No unused plugins to clean", vim.log.levels.INFO)
			else
				vim.notify("Removing: " .. table.concat(unused, ", "), vim.log.levels.INFO)
				for _, name in ipairs(unused) do
					vim.pack.del({ name }, { force = true })
				end
				vim.notify("Done! Removed " .. #unused .. " plugins", vim.log.levels.INFO)
			end
		end, section = "Plugins" },
		-- Session
		{ name = "q  Quit", action = "qa", section = "Session" },
	},
	content_hooks = {
		starter.gen_hook.aligning("center", "center"),
	},
	footer = "",
})

-- Disable folding in starter buffer
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("ClaudlosStarter", { clear = true }),
	pattern = "ministarter",
	callback = function()
		vim.opt_local.foldenable = false
	end,
})
