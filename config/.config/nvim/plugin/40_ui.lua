-- ── 40_ui.lua ──────────────────────────────────
-- Neovim config: Colorscheme and visual enhancements.
-- Loads early (02 prefix) so colors are set before first draw.

vim.pack.add({
	"https://github.com/catppuccin/nvim",
	"https://github.com/HiPhish/rainbow-delimiters.nvim",
	"https://github.com/f-person/auto-dark-mode.nvim",
	"https://github.com/lukas-reineke/indent-blankline.nvim",
})

-- ── Catppuccin ─────────────────────────────────
require("catppuccin").setup({
	flavour = "auto",
	background = {
		light = "latte",
		dark = "mocha", -- explicit dark default
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

				NvimTablineCurrent = { fg = c.crust, bg = c.mauve, bold = true },
				NvimTablineHidden = { fg = c.text, bg = c.surface0 },
				NvimTablineHarpoonCurrent = { fg = c.crust, bg = c.lavender, bold = true },
				NvimTablineHarpoonHidden = { fg = c.lavender, bg = c.surface1, bold = true },
				NvimTablineFill = { fg = c.overlay0, bg = c.base },
				NvimTablineSection = { fg = c.crust, bg = c.sapphire, bold = true },
			}
		end,
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
vim.o.showtabline = 2
vim.o.tabline = "%!v:lua.require'tabline'.render()"

-- ── Auto Dark Mode ─────────────────────────────
require("auto-dark-mode").setup({
	update_interval = 1000,
	set_dark_mode = function()
		vim.api.nvim_set_option_value("background", "dark", {})
		vim.cmd.colorscheme("catppuccin-mocha")
	end,
	set_light_mode = function()
		vim.api.nvim_set_option_value("background", "light", {})
		vim.cmd.colorscheme("catppuccin-latte")
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
		filetypes = { "help", "alpha", "mason", "checkhealth" },
	},
})

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
		"",
		get_quote(),
	}, "\n")
end

starter.setup({
	header = build_header,
	items = {
		-- Files
		{ name = "f  Find files", action = function() require("fzf-lua").files() end, section = "Files" },
		{ name = "g  Live grep", action = function() require("fzf-lua").live_grep() end, section = "Files" },
		{ name = "r  Recent files", action = function() require("fzf-lua").oldfiles() end, section = "Files" },
		{
			name = "t  TODOs",
			action = function()
				require("fzf-lua").grep({ search = "TODO|FIXME|HACK|NOTE|WARN" })
			end,
			section = "Files",
		},
		-- Config
		{ name = "e  Edit config", action = "e " .. vim.fn.stdpath("config") .. "/init.lua", section = "Config" },
		{ name = "k  Keymaps", action = "e " .. vim.fn.stdpath("config") .. "/KEYMAPS.md", section = "Config" },
		{ name = "c  Commands", action = "e " .. vim.fn.stdpath("config") .. "/COMMANDS.md", section = "Config" },
		-- Plugins
		{ name = "u  Update plugins", action = "lua vim.pack.update()", section = "Plugins" },
		{
			name = "x  Clean plugins",
			action = function()
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
				else
					vim.notify("Removing: " .. table.concat(unused, ", "), vim.log.levels.INFO)
					for _, name in ipairs(unused) do
						vim.pack.del({ name }, { force = true })
					end
					vim.notify("Done! Removed " .. #unused .. " plugins", vim.log.levels.INFO)
				end
			end,
			section = "Plugins",
		},
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
	group = vim.api.nvim_create_augroup("NvimConfigStarter", { clear = true }),
	pattern = "ministarter",
	callback = function()
		vim.opt_local.foldenable = false
	end,
})
