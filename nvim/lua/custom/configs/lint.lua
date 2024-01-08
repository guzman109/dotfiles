local lint = require "lint"
lint.linters_by_ft = {
  python = { "mypy", "pylint", "ruff" },
--   cpp = { "clangtidy" },
--   cmake = { "cmakelint" },
  javascript = { "eslint" },
  typescript = { "eslint" },
  dockerfile = { "hadolint" },
  vue = { "eslint" }
}
      vim.keymap.set("n", "<leader>fl", function()
        lint.try_lint()
      end, { desc = "Lint Current File" })
