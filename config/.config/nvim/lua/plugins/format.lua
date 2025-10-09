return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      swift = { "swiftformat" },
      python = { "ruff_format" }, -- Use ruff for Python
      zig = { "zigfmt" },
      -- Add other languages as needed
    },
    
    -- Format on save configuration
    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 500,
      lsp_fallback = true, -- Use LSP if conform formatter fails
    },
    
    -- Formatter-specific settings
    formatters = {
      swiftformat = {
        command = "/opt/homebrew/bin/swiftformat",
        args = {
          "--indent", "4",
          "--indentcase", "false",
          "--trimwhitespace", "always",
          "--wraparguments", "before-first",
          "--wrapcollections", "before-first",
          "--self", "insert", -- Use explicit self
          "--importgrouping", "alphabetized",
          "$FILENAME",
        },
        stdin = false, -- swiftformat works on files directly
      },
      
      ruff_format = {
        command = "/Users/guzman.109/.local/bin/ruff",
        args = { "format", "--stdin-filename", "$FILENAME", "-" },
        stdin = true,
      },
      
      zigfmt = {
        command = "zig",
        args = { "fmt", "--stdin" },
        stdin = true,
      },
    },
  },
}
