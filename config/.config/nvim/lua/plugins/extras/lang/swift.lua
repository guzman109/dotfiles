return {
  -- Treesitter for Swift syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "swift",
      },
    },
  },

  -- LSP configuration for Swift (SourceKit)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sourcekit = {
          cmd = { "sourcekit-lsp" },
          filetypes = { "swift" },
          autostart = true,
        },
      },
    },
  },

  -- Formatter: swiftformat
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        swift = { "swiftformat" },
      },
      formatters = {
        swiftformat = {
          command = "/opt/homebrew/bin/swiftformat",
          args = {
            "--indent",
            "4",
            "--indentcase",
            "false",
            "--trimwhitespace",
            "always",
            "--wraparguments",
            "before-first",
            "--wrapcollections",
            "before-first",
            "--self",
            "insert",
            "--importgrouping",
            "alphabetized",
            "$FILENAME",
          },
          stdin = false,
        },
      },
    },
  },

  -- Linter: swiftlint
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        swift = { "swiftlint" },
      },
    },
  },
  {
    "wojciech-kulik/xcodebuild.nvim",
    -- Only load in directories with Xcode projects
    cond = function()
      local util = require("lspconfig.util")
      return util.root_pattern("*.xcodeproj", "*.xcworkspace")(vim.fn.getcwd()) ~= nil
    end,
    config = function()
      require("xcodebuild").setup({
        -- put some options here or leave it empty to use default settings
        vim.keymap.set("n", "<leader>X", "<cmd>XcodebuildPicker<cr>", { desc = "Xcodebuild" }),
        vim.keymap.set(
          "n",
          "<leader>Xf",
          "<cmd>XcodebuildProjectManager<cr>",
          { desc = "Show Project Manager Actions" }
        ),

        vim.keymap.set("n", "<leader>Xb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" }),
        vim.keymap.set("n", "<leader>XB", "<cmd>XcodebuildBuildForTesting<cr>", { desc = "Build For Testing" }),
        vim.keymap.set("n", "<leader>Xr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Build & Run Project" }),

        vim.keymap.set("n", "<leader>Xt", "<cmd>XcodebuildTest<cr>", { desc = "Run Tests" }),
        vim.keymap.set("v", "<leader>Xt", "<cmd>XcodebuildTestSelected<cr>", { desc = "Run Selected Tests" }),
        vim.keymap.set("n", "<leader>XT", "<cmd>XcodebuildTestClass<cr>", { desc = "Run Current Test Class" }),
        vim.keymap.set("n", "<leader>X.", "<cmd>XcodebuildTestRepeat<cr>", { desc = "Repeat Last Test Run" }),

        vim.keymap.set("n", "<leader>Xl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Toggle Xcodebuild Logs" }),
        vim.keymap.set("n", "<leader>Xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", { desc = "Toggle Code Coverage" }),
        vim.keymap.set(
          "n",
          "<leader>XC",
          "<cmd>XcodebuildShowCodeCoverageReport<cr>",
          { desc = "Show Code Coverage Report" }
        ),
        vim.keymap.set("n", "<leader>Xe", "<cmd>XcodebuildTestExplorerToggle<cr>", { desc = "Toggle Test Explorer" }),
        vim.keymap.set("n", "<leader>Xs", "<cmd>XcodebuildFailingSnapshots<cr>", { desc = "Show Failing Snapshots" }),

        vim.keymap.set("n", "<leader>Xp", "<cmd>XcodebuildPreviewGenerateAndShow<cr>", { desc = "Generate Preview" }),
        vim.keymap.set("n", "<leader>X<cr>", "<cmd>XcodebuildPreviewToggle<cr>", { desc = "Toggle Preview" }),

        vim.keymap.set("n", "<leader>Xd", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device" }),
        vim.keymap.set("n", "<leader>Xq", "<cmd>Telescope quickfix<cr>", { desc = "Show QuickFix List" }),

        vim.keymap.set("n", "<leader>Xx", "<cmd>XcodebuildQuickfixLine<cr>", { desc = "Quickfix Line" }),
        vim.keymap.set("n", "<leader>Xa", "<cmd>XcodebuildCodeActions<cr>", { desc = "Show Code Actions" }),
      })
    end,
  },
}
