local util = require("tabby.util")
local palette = require("catppuccin.palettes").get_palette()

local hl_fill = { fg = palette.subtext0, bg = "NONE" }
local hl_tab = { fg = palette.subtext0, bg = palette.surface0 }
local hl_sel = { fg = palette.base, bg = palette.red }

local function is_harpooned(bufnr)
	local ok, harpoon = pcall(require, "harpoon")
	if not ok then
		return false
	end
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	for _, item in ipairs(harpoon:list().items) do
		if item.value and item.value ~= "" and bufname:sub(-#item.value) == item.value then
			return true
		end
	end
	return false
end

local function tab_label(tabid)
	local winid = vim.api.nvim_tabpage_get_win(tabid)
	local bufnr = vim.api.nvim_win_get_buf(winid)
	local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
	if name == "" then
		name = "[No Name]"
	end

	-- Check for named terminal buffers (e.g. "Claude") before generic fallback
	if vim.bo[bufnr].buftype == "terminal" then
		local bufname = vim.api.nvim_buf_get_name(bufnr)
		if bufname:match("Claude$") then
			name = "Claude"
		else
			name = "Terminal"
		end
	end

	local ft = vim.bo[bufnr].filetype
	local icon = ""
	local ok, mini_icons = pcall(require, "mini.icons")
	if ok then
		if vim.bo[bufnr].buftype == "terminal" then
			if name == "Claude" then
				icon = "󰚩"
			else
				icon = ""
			end
		else
			icon = mini_icons.get("filetype", ft) or ""
		end
	end

	local harp = is_harpooned(bufnr) and " 󰛢" or ""
	local number = vim.api.nvim_tabpage_get_number(tabid)
	return string.format(" %s %d: %s%s ", icon, number, name, harp)
end

local presets = {
	hl = { bg = "NONE" },
	layout = "tab_only",
	active_tab = {
		label = function(tabid)
			return {
				tab_label(tabid),
				hl = { fg = hl_sel.fg, bg = hl_sel.bg, style = "bold" },
			}
		end,
		-- LEFT BUBBLE: <C-v>ue0b6  (nf-ple-left_half_circle_thick)
		left_sep = { "", hl = { fg = hl_sel.bg, bg = "NONE" } },
		-- RIGHT BUBBLE: <C-v>ue0b4  (nf-ple-right_half_circle_thick)
		right_sep = { "", hl = { fg = hl_sel.bg, bg = "NONE" } },
		--             ^ put cursor here, type <C-v>ue0b4
	},
	inactive_tab = {
		label = function(tabid)
			return {
				tab_label(tabid),
				hl = { fg = hl_tab.fg, bg = hl_tab.bg },
			}
		end,
		-- LEFT SEPARATOR: <C-v>ue0b6 (left half circle)
		left_sep = { "", hl = { fg = hl_tab.bg, bg = "NONE" } },
		-- RIGHT SEPARATOR: <C-v>ue0b4 (right half circle)
		right_sep = { "", hl = { fg = hl_tab.bg, bg = "NONE" } },
	},
}

return presets
