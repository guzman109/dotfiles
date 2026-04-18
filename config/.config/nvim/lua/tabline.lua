local M = {}

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

local function tab_parts(tabid)
	local winid = vim.api.nvim_tabpage_get_win(tabid)
	local bufnr = vim.api.nvim_win_get_buf(winid)
	local agent_id = vim.b[bufnr].ai_agent_id
	local ok, tab_title = pcall(vim.api.nvim_tabpage_get_var, tabid, "title")
	local name = ok and tab_title or vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")

	if name == "" then
		name = "[No Name]"
	end

	local icon = nil
	if agent_id == "claude" then
		name = "Claude"
		icon = ""
	elseif agent_id == "codex" then
		name = "Codex"
		icon = ""
	elseif _G.MiniIcons then
		local path = vim.api.nvim_buf_get_name(bufnr)
		icon = select(1, MiniIcons.get("file", path ~= "" and path or name))
	end

	local body = icon and string.format("%s %s", icon, name) or name

	if vim.bo[bufnr].modified then
		body = body .. "  ●"
	end

	return body
end

function M.render()
	local current = vim.api.nvim_get_current_tabpage()
	local tabs = vim.api.nvim_list_tabpages()
	local parts = {}

	for _, tabid in ipairs(tabs) do
		local is_current = tabid == current
		local winid = vim.api.nvim_tabpage_get_win(tabid)
		local bufnr = vim.api.nvim_win_get_buf(winid)
		local is_marked = is_harpooned(bufnr)

		local body_hl, fade1_hl, fade2_hl, fade3_hl
		if is_current and is_marked then
			body_hl = "%#NvimTablineHarpoonCurrent#"
			fade1_hl = "%#NvimTablineHarpoonCurrentFade1#"
			fade2_hl = "%#NvimTablineHarpoonCurrentFade2#"
			fade3_hl = "%#NvimTablineHarpoonCurrentFade3#"
		elseif is_current then
			body_hl = "%#NvimTablineCurrent#"
			fade1_hl = "%#NvimTablineCurrentFade1#"
			fade2_hl = "%#NvimTablineCurrentFade2#"
			fade3_hl = "%#NvimTablineCurrentFade3#"
		elseif is_marked then
			body_hl = "%#NvimTablineHarpoonHidden#"
			fade1_hl = "%#NvimTablineHarpoonHiddenFade1#"
			fade2_hl = "%#NvimTablineHarpoonHiddenFade2#"
			fade3_hl = "%#NvimTablineHarpoonHiddenFade3#"
		else
			body_hl = "%#NvimTablineHidden#"
			fade1_hl = "%#NvimTablineHiddenFade1#"
			fade2_hl = "%#NvimTablineHiddenFade2#"
			fade3_hl = "%#NvimTablineHiddenFade3#"
		end

		local nr = vim.api.nvim_tabpage_get_number(tabid)
		local body = tab_parts(tabid)

		table.insert(parts, string.format("%%%dT", nr))

		table.insert(parts, fade3_hl .. "█")
		table.insert(parts, fade2_hl .. "█")
		table.insert(parts, fade1_hl .. "█")

		table.insert(parts, body_hl .. string.format(" %d: %s ", nr, body))

		table.insert(parts, fade1_hl .. "█")
		table.insert(parts, fade2_hl .. "█")
		table.insert(parts, fade3_hl .. "█")

		table.insert(parts, "%#NvimTablineFill# ")
		table.insert(parts, "%T")
	end

	table.insert(parts, "%#NvimTablineFill#%=")

	if #tabs > 1 then
		table.insert(
			parts,
			string.format("%%#NvimTablineSection# %d/%d ", vim.api.nvim_tabpage_get_number(current), #tabs)
		)
	end

	return table.concat(parts, "")
end

return M
