-- ── 70_completion.lua ──────────────────────
-- Neovim config: blink.cmp — fast, Rust-based completion.

vim.pack.add({
	-- Pin to release tag so prebuilt Rust fuzzy binary auto-downloads
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
})

require("blink.cmp").setup({
	keymap = {
		preset = "default",
		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-e>"] = { "hide" },
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
		["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
		["<C-n>"] = { "select_next", "fallback" },
		["<C-p>"] = { "select_prev", "fallback" },
		["<C-d>"] = { "scroll_documentation_down", "fallback" },
		["<C-u>"] = { "scroll_documentation_up", "fallback" },
	},
	appearance = {
		use_nvim_cmp_as_default = false,
		nerd_font_variant = "mono",
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
		menu = {
			draw = {
				columns = {
					{ "kind_icon" },
					{ "label", "label_description", gap = 1 },
				},
				components = {
					kind_icon = {
						text = function(ctx)
							local icon = ctx.kind_icon
							if ctx.item.source_name == "LSP" then
								local color_item = require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
								if color_item and color_item.abbr ~= "" then
									icon = color_item.abbr
								end
							end
							return icon .. ctx.icon_gap
						end,
						highlight = function(ctx)
							if ctx.item.source_name == "LSP" then
								local color_item = require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
								if color_item and color_item.abbr_hl_group then
									return color_item.abbr_hl_group
								end
							end
							return "BlinkCmpKind" .. ctx.kind
						end,
					},
				},
			},
		},
	},
	cmdline = {
		enabled = true,
		keymap = {
			preset = "none",
			["<Tab>"] = { "show", "select_next", "fallback" },
			["<S-Tab>"] = { "show", "select_prev", "fallback" },
			["<Space>"] = { "select_and_accept", "fallback" },
			["<C-space>"] = { "show", "fallback" },
			["<C-e>"] = { "cancel", "fallback" },
		},
		completion = {
			menu = {
				auto_show = function()
					return vim.fn.getcmdtype() == ":"
				end,
			},
			list = {
				selection = {
					preselect = true,
					auto_insert = false,
				},
			},
			ghost_text = {
				enabled = false,
			},
		},
	},
	signature = {
		enabled = true,
	},
	fuzzy = {
		implementation = "rust",
	},
})
