local null_ls = require "null-ls"

null_ls.setup {
  sources = {
    -- Formatters
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.ruff,
    null_ls.builtins.formatting.clang_format,
    null_ls.builtins.formatting.cmake_format,
    null_ls.builtins.formatting.mdformat,
    null_ls.builtins.formatting.yamlfix,
    -- Linters
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.diagnostics.mypy,
    null_ls.builtins.diagnostics.pylint,
    null_ls.builtins.diagnostics.cmake_lint,
    null_ls.builtins.diagnostics.hadolint,
  },
}
