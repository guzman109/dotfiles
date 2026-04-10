-- ── 90_ai.lua ──────────────────────────────────
-- Neovim config: AI agents — Claude Code + Codex CLI.

local agents = {
	{
		id = "claude",
		cmd = "claude",
		label = "Claude Code",
		models = {
			{ label = "Sonnet *", value = nil },
			{ label = "Opus", value = "opus" },
			{ label = "Haiku", value = "haiku" },
		},
	},
	{
		id = "codex",
		cmd = "codex",
		label = "Codex",
		models = {
			{ label = "Configured Default *", value = nil },
			{ label = "GPT-5.2 Pro", value = "gpt-5.2-pro" },
			{ label = "GPT-5.2", value = "gpt-5.2" },
			{ label = "GPT-5.2 Chat", value = "gpt-5.2-chat-latest" },
			{ label = "GPT-5.2 Codex", value = "gpt-5.2-codex" },
			{ label = "GPT-5.1", value = "gpt-5.1" },
			{ label = "GPT-5.1 Chat", value = "gpt-5.1-chat-latest" },
			{ label = "GPT-5.1 Codex", value = "gpt-5.1-codex" },
			{ label = "GPT-5.1 Codex Max", value = "gpt-5.1-codex-max" },
			{ label = "GPT-5.1 Codex Mini", value = "gpt-5.1-codex-mini" },
			{ label = "GPT-5", value = "gpt-5" },
			{ label = "GPT-5 Chat", value = "gpt-5-chat-latest" },
			{ label = "GPT-5 Codex", value = "gpt-5-codex" },
			{ label = "GPT-5 Mini", value = "gpt-5-mini" },
			{ label = "GPT-5 Nano", value = "gpt-5-nano" },
		},
	},
}

local function read_codex_default_model()
	local path = vim.fn.expand("~/.codex/config.toml")
	local lines = vim.fn.readfile(path)
	for _, line in ipairs(lines) do
		local model = line:match('^%s*model%s*=%s*"(.-)"%s*$')
		if model and model ~= "" then
			return model
		end
	end
end

local function apply_default_model_labels()
	local codex_default = read_codex_default_model()
	for _, agent in ipairs(agents) do
		if agent.id == "codex" and codex_default and agent.models and agent.models[1] then
			agent.models[1].label = string.format("%s *", codex_default)
		end
	end
end

apply_default_model_labels()

-- Per-session state: { agent_id = S, model = S|nil, chan = N, bufnr = N }
local state = {}
local last_key = nil

local function session_key(agent_id, model)
	return string.format("%s::%s", agent_id, model or "default")
end

local function is_alive(key)
	local s = state[key]
	if not s or not vim.api.nvim_buf_is_valid(s.bufnr) then
		state[key] = nil
		return false
	end
	return vim.fn.jobwait({ s.chan }, 0)[1] == -1
end

local function any_session_open(agent_id)
	for key, s in pairs(state) do
		if s.agent_id == agent_id and is_alive(key) then
			return true
		end
	end
	return false
end

local function build_cmd(agent, model)
	local cmd = agent.cmd
	if model and model ~= "" then
		cmd = string.format("%s --model %s", cmd, vim.fn.shellescape(model))
	end
	return cmd
end

local function buffer_label(agent, model)
	if model and model ~= "" then
		return string.format("%s [%s]", agent.label, model)
	end
	return agent.label
end

local function set_agent_buffer_meta(bufnr, agent, model, label)
	vim.bo[bufnr].bufhidden = "wipe"
	vim.bo[bufnr].buflisted = true
	vim.b[bufnr].ai_agent_id = agent.id
	vim.b[bufnr].ai_agent_label = agent.label
	vim.b[bufnr].ai_agent_model = model or ""
	vim.b[bufnr].ai_agent_tab_label = label
end

local function pick(title, items, callback)
	vim.ui.select(items, {
		prompt = title,
		format_item = function(item)
			return item.text
		end,
	}, function(choice)
		if choice then
			callback(choice.value)
		end
	end)
end

local function pick_agent(callback)
	local items = {}
	for _, agent in ipairs(agents) do
		table.insert(items, {
			text = string.format("%-14s%s", agent.label, any_session_open(agent.id) and " [open]" or ""),
			value = agent,
		})
	end
	pick("Agent  ", items, callback)
end

local function pick_model(agent, callback)
	if not agent.models or #agent.models == 0 then
		callback(nil)
		return
	end

	local items = {}
	for _, model in ipairs(agent.models) do
		local key = session_key(agent.id, model.value)
		table.insert(items, {
			text = string.format("%-14s%s", model.label, is_alive(key) and " [open]" or ""),
			value = model,
		})
	end
	pick("Model  ", items, function(choice)
		callback(choice and choice.value or nil)
	end)
end

local function pick_agent_and_model(callback)
	pick_agent(function(agent)
		pick_model(agent, function(model)
			callback(agent, model)
		end)
	end)
end

-- Focus existing tab/win or spawn fresh. Returns true if already existed.
local function focus_or_open(agent, model)
	local key = session_key(agent.id, model)
	if is_alive(key) then
		local bufnr = state[key].bufnr
		for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
			for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
				if vim.api.nvim_win_get_buf(win) == bufnr then
					vim.api.nvim_set_current_tabpage(tab)
					vim.api.nvim_set_current_win(win)
					last_key = key
					return true
				end
			end
		end
		-- Buffer alive but not visible — open in new tab
		vim.cmd("tabnew")
		vim.api.nvim_win_set_buf(0, bufnr)
		last_key = key
		return true
	end

	vim.cmd("tabnew | terminal " .. build_cmd(agent, model))
	local bufnr = vim.api.nvim_get_current_buf()
	local label = buffer_label(agent, model)
	state[key] = {
		agent_id = agent.id,
		model = model,
		chan = vim.bo.channel,
		bufnr = bufnr,
	}
	vim.cmd("file " .. label)
	set_agent_buffer_meta(bufnr, agent, model, label)
	last_key = key
	return false
end

-- ── Keymaps ────────────────────────────────────

-- Open / focus agent
vim.keymap.set("n", "<leader>ac", function()
	pick_agent_and_model(focus_or_open)
end, { desc = "Open AI agent" })

-- Always open a brand-new agent tab
local new_tab_counter = 0
local function open_new(agent, model)
	new_tab_counter = new_tab_counter + 1
	local key = string.format("%s::%s::new%d", agent.id, model or "default", new_tab_counter)
	vim.cmd("tabnew | terminal " .. build_cmd(agent, model))
	local bufnr = vim.api.nvim_get_current_buf()
	state[key] = {
		agent_id = agent.id,
		model = model,
		chan = vim.bo.channel,
		bufnr = bufnr,
	}
	local label = buffer_label(agent, model)
	if vim.fn.bufnr(label) ~= -1 then
		label = string.format("%s #%d", label, new_tab_counter)
	end
	vim.api.nvim_buf_set_name(0, label)
	set_agent_buffer_meta(bufnr, agent, model, label)
	last_key = key
end

vim.keymap.set("n", "<leader>an", function()
	pick_agent_and_model(open_new)
end, { desc = "New AI agent tab" })

-- Add current file to agent
vim.keymap.set("n", "<leader>af", function()
	local file = vim.fn.expand("%:p")
	local fname = vim.fn.expand("%:t")

	local function send(agent, model)
		local key = session_key(agent.id, model)
		vim.fn.chansend(state[key].chan, "@" .. file .. " ")
		vim.notify("Added " .. fname .. " → " .. buffer_label(agent, model), vim.log.levels.INFO)
	end

	-- Reuse last session if still alive
	if last_key and is_alive(last_key) then
		local s = state[last_key]
		for _, a in ipairs(agents) do
			if a.id == s.agent_id then
				send(a, s.model)
				return
			end
		end
	end

	pick_agent_and_model(function(agent, model)
		local already_open = focus_or_open(agent, model)
		if already_open then
			send(agent, model)
		else
			vim.defer_fn(function()
				send(agent, model)
			end, 1000)
		end
	end)
end, { desc = "Add file to AI agent" })
