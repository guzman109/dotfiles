local opts = {
  ensure_installed = {
    -- LSP
    "lua-language-server",
    "ruff-lsp",
    "marksman",
    "clangd",
    "cmake-language-server",
    "vue-language-server",
    "typescript-language-server",
    -- Formatters
    "stylua",
    "prettierd",
    "ruff",
    "clang-format",
    "cmakelang",
    "mdformat",
    "yamlfix",
    -- Linters
    "mypy",
    "pylint",
    "eslint_d",
    -- Debuggers
    "debugpy",
    "codelldb",
  },
}
return opts
