-- ── 80_dap.lua ─────────────────────────────────
-- Neovim config: Debug Adapter Protocol.

vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-dap", name = "nvim-dap" },
	{ src = "https://github.com/rcarriga/nvim-dap-ui", name = "nvim-dap-ui" },
	{ src = "https://github.com/nvim-neotest/nvim-nio", name = "nvim-nio" },
	{ src = "https://github.com/mfussenegger/nvim-dap-python", name = "nvim-dap-python" },
})

local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

-- Auto open/close DAP UI
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

-- ── Adapters ───────────────────────────────────

local function executable(paths)
	for _, path in ipairs(paths) do
		if vim.fn.executable(path) == 1 then
			return path
		end
	end
	return paths[1]
end

-- lldb-dap (C/C++/Zig — provided by Homebrew llvm or PATH)
dap.adapters.lldb = {
	type = "executable",
	command = executable({
		"lldb-dap",
		"/opt/homebrew/opt/llvm/bin/lldb-dap",
		"/usr/local/opt/llvm/bin/lldb-dap",
		"/Applications/Xcode.app/Contents/Developer/usr/bin/lldb-dap",
	}),
	name = "lldb",
}

-- debugpy (Python — installed via uv)
local dap_python = require("dap-python")
dap_python.setup("python3")
dap_python.test_runner = "pytest"

-- ── Configurations ─────────────────────────────

dap.configurations.c = {
	{
		name = "Launch",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}
dap.configurations.cpp = dap.configurations.c

dap.configurations.zig = {
	{
		name = "Launch (Zig)",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/zig-out/bin/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},
	},
}

-- ── Keymaps ────────────────────────────────────
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<leader>dB", function()
	dap.set_breakpoint(vim.fn.input("Condition: "))
end, { desc = "Conditional breakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step out" })
vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "Restart" })
vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
vim.keymap.set("n", "<leader>de", function()
	dapui.eval()
end, { desc = "Eval under cursor" })
vim.keymap.set("v", "<leader>de", function()
	dapui.eval()
end, { desc = "Eval selection" })
