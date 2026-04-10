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
	local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
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

	local marks = {}
	if vim.bo[bufnr].modified then
		table.insert(marks, "●")
	end

	local body = icon and string.format("%s %s", icon, name) or name
	if #marks > 0 then
		body = body .. " " .. table.concat(marks, " ")
	end

	return body
end

function M.render()
	local current = vim.api.nvim_get_current_tabpage()
	local parts = {}

	for _, tabid in ipairs(vim.api.nvim_list_tabpages()) do
		local is_current = tabid == current
		local winid = vim.api.nvim_tabpage_get_win(tabid)
		local bufnr = vim.api.nvim_win_get_buf(winid)
		local is_marked = is_harpooned(bufnr)
		local hl
		if is_current and is_marked then
			hl = "%#NvimTablineHarpoonCurrent#"
		elseif is_current then
			hl = "%#NvimTablineCurrent#"
		elseif is_marked then
			hl = "%#NvimTablineHarpoonHidden#"
		else
			hl = "%#NvimTablineHidden#"
		end
		local nr = vim.api.nvim_tabpage_get_number(tabid)
		local body = tab_parts(tabid)
		table.insert(parts, string.format("%%%dT%s%d:%s%%T", nr, hl, nr, body))
		table.insert(parts, "%#NvimTablineFill#│")
	end

	table.insert(parts, "%#NvimTablineFill#%=")
	if #vim.api.nvim_list_tabpages() > 1 then
		table.insert(parts, string.format("%%#NvimTablineSection# Tabs %d/%d ", vim.api.nvim_tabpage_get_number(current), #vim.api.nvim_list_tabpages()))
	end

	return table.concat(parts, "")
end

return M
