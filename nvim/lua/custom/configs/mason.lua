local opts = {
  ensure_installed = {
    -- LSP
    "lua-language-server",
    "ruff-lsp",
    "marksman",
    "clangd",
    "cmake-language-server",
    "vetur-vls",
    "typescript-language-server",
    "dockerfile-language-server",
    "docker-compose-language-service",
    -- Formatters
    "stylua",
    "prettier",
    "ruff",
    "clang-format",
    "cmakelang",
    "mdformat",
    -- Linters
    "mypy",
    "pylint",
    "hadolint",
    -- Debuggers
    "debugpy",
    "codelldb",
  },
}
return opts
