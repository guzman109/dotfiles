local conform = require "conform"

conform.setup {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    markdown = { "mdformat" },
    cpp = { "clang-format" },
    cmake = { "cmake_format" },
    python = { "ruff_format" },
    typescript = { "prettier" },
    javascript = { "prettier" },
    vue = { "prettier" },
  },
}
      vim.keymap.set({ "n", "v" }, "<leader>fm", function()
        conform.format {
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        }
      end, { desc = "Format Current File" })
