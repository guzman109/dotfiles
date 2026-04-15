vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = true
vim.opt_local.indentexpr = ""

-- ── Xcode keymaps (Swift-only) ─────────────────
local map = function(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { buffer = true, desc = desc })
end

map("n", "<leader>cxx", "<cmd>XcodebuildPicker<cr>", "Xcode actions")
map("n", "<leader>cxu", "<cmd>XcodebuildSetup<cr>", "Setup project")
map("n", "<leader>cxh", "<cmd>checkhealth xcodebuild<cr>", "Check health")
map("n", "<leader>cxf", "<cmd>XcodebuildProjectManager<cr>", "Project manager")
map("n", "<leader>cxb", "<cmd>XcodebuildBuild<cr>", "Build")
map("n", "<leader>cxB", "<cmd>XcodebuildBuildForTesting<cr>", "Build for testing")
map("n", "<leader>cxr", "<cmd>XcodebuildBuildRun<cr>", "Build and run")
map("n", "<leader>cxR", "<cmd>XcodebuildRun<cr>", "Run app (no build)")
map("n", "<leader>cxt", "<cmd>XcodebuildTest<cr>", "Run tests")
map("v", "<leader>cxt", "<cmd>XcodebuildTestSelected<cr>", "Run selected tests")
map("n", "<leader>cxn", "<cmd>XcodebuildTestNearest<cr>", "Run nearest test")
map("n", "<leader>cxT", "<cmd>XcodebuildTestClass<cr>", "Run test class")
map("n", "<leader>cxg", "<cmd>XcodebuildTestTarget<cr>", "Run test target")
map("n", "<leader>cx.", "<cmd>XcodebuildTestRepeat<cr>", "Repeat last test")
map("n", "<leader>cxe", "<cmd>XcodebuildTestExplorerToggle<cr>", "Toggle test explorer")
map("n", "<leader>cxl", "<cmd>XcodebuildToggleLogs<cr>", "Toggle logs")
map("n", "<leader>cxc", "<cmd>XcodebuildToggleCodeCoverage<cr>", "Toggle coverage")
map("n", "<leader>cxC", "<cmd>XcodebuildShowCodeCoverageReport<cr>", "Coverage report")
map("n", "<leader>cxj", "<cmd>XcodebuildJumpToNextCoverage<cr>", "Next coverage mark")
map("n", "<leader>cxk", "<cmd>XcodebuildJumpToPrevCoverage<cr>", "Prev coverage mark")
map("n", "<leader>cxs", "<cmd>XcodebuildSelectScheme<cr>", "Select scheme")
map("n", "<leader>cxd", "<cmd>XcodebuildSelectDevice<cr>", "Select device")
map("n", "<leader>cxa", "<cmd>XcodebuildCodeActions<cr>", "Xcode code actions")
map("n", "<leader>cxX", "<cmd>XcodebuildCleanBuild<cr>", "Clean build")
map("n", "<leader>cxD", "<cmd>XcodebuildCleanDerivedData<cr>", "Clean derived data")
map("n", "<leader>cxo", "<cmd>XcodebuildOpenInXcode<cr>", "Open in Xcode")
map("n", "<leader>cxm", "<cmd>XcodebuildApproveMacros<cr>", "Approve Swift macros")
map("n", "<leader>cxq", "<cmd>XcodebuildCancel<cr>", "Cancel action")
map("n", "<leader>cxp", "<cmd>XcodebuildPreviewGenerateAndShow<cr>", "Generate preview")
map("n", "<leader>cxP", "<cmd>XcodebuildPreviewToggle<cr>", "Toggle preview")

map("n", "<leader>cxN", function()
	local kinds = { "iOS App", "macOS App", "Swift Package" }
	vim.ui.select(kinds, { prompt = "Project kind" }, function(kind)
		if not kind then
			return
		end
		local name = vim.fn.input("Project name: ")
		if name == "" then
			return
		end
		local dir = vim.fn.getcwd() .. "/" .. name
		vim.fn.mkdir(dir .. "/Sources", "p")

		if kind == "iOS App" or kind == "macOS App" then
			local platform = kind == "iOS App" and "iOS" or "macOS"
			local deploy = kind == "iOS App" and "17.0" or "14.0"
			local yml = string.format(
				'name: %s\noptions:\n  bundleIdPrefix: com.example\ntargets:\n  %s:\n    type: application\n    platform: %s\n    deploymentTarget: "%s"\n    sources: [Sources]\n',
				name,
				name,
				platform,
				deploy
			)
			if kind == "iOS App" then
				yml = yml .. "    info:\n      path: Info.plist\n      properties:\n        UILaunchScreen: {}\n"
			end
			vim.fn.writefile(vim.split(yml, "\n"), dir .. "/project.yml")
			vim.fn.writefile({
				"import SwiftUI",
				"",
				"@main",
				"struct " .. name .. "App: App {",
				'    var body: some Scene { WindowGroup { Text("Hello") } }',
				"}",
			}, dir .. "/Sources/" .. name .. "App.swift")
			vim.fn.system("cd " .. vim.fn.shellescape(dir) .. " && xcodegen generate")
			vim.fn.system(
				"cd "
					.. vim.fn.shellescape(dir)
					.. " && xcode-build-server config -project "
					.. vim.fn.shellescape(name .. ".xcodeproj")
					.. " -scheme "
					.. vim.fn.shellescape(name)
			)
			vim.cmd("lcd " .. vim.fn.fnameescape(dir))
			vim.cmd("e .")
			vim.notify(kind .. " created: " .. name, vim.log.levels.INFO)
			vim.defer_fn(function()
				vim.cmd("XcodebuildSetup")
			end, 500)
		else
			local pkg_types = { "library", "executable", "macro", "build-tool-plugin" }
			vim.ui.select(pkg_types, { prompt = "Package type" }, function(ptype)
				if not ptype then
					return
				end
				vim.fn.system(
					string.format(
						"cd %s && swift package init --name %s --type %s",
						vim.fn.shellescape(dir),
						vim.fn.shellescape(name),
						ptype
					)
				)
				vim.cmd("lcd " .. vim.fn.fnameescape(dir))
				vim.cmd("e .")
				vim.notify("Swift Package (" .. ptype .. ") created: " .. name, vim.log.levels.INFO)
			end)
		end
	end)
end, "New Swift project")
