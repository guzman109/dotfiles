return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
          -- Format diagnostics to show source clearly
          format = function(diagnostic)
            local source_prefix = {
              sourcekit = "[Swift]",
              ty = "[Ty]",
              ruff = "[Ruff]",
              zls = "[Zig]",
            }
            local prefix = source_prefix[diagnostic.source] or string.format("[%s]", diagnostic.source or "?")
            return string.format("%s %s", prefix, diagnostic.message)
          end,
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      },
      -- Setup order - ensure language servers initialize before spell checkers
      setup = {
        sourcekit = function(_, opts)
          require("lspconfig").sourcekit.setup(opts)
          return true
        end,
        -- ty = function(_, opts)
        --   require("lspconfig").ty.setup(opts)
        --   return true
        -- end,
        -- ruff = function(_, opts)
        --   require("lspconfig").ruff.setup(opts)
        --   return true
        -- end,
        -- zls = function(_, opts)
        --   require("lspconfig").zls.setup(opts)
        --   return true
        -- end,
      },
      servers = {
        -- Swift LSP (SourceKit)
        sourcekit = {
          filetypes = { "swift" },
          autostart = true,
          capabilities = {
            textDocument = {
              completion = {
                completionItem = {
                  snippetSupport = true,
                  resolveSupport = {
                    properties = { "documentation", "detail", "additionalTextEdits" },
                  },
                },
              },
            },
          },
          root_dir = function(filename, bufnr)
            local fname = type(filename) == "string" and filename
              or (type(bufnr) == "number" and vim.api.nvim_buf_get_name(bufnr))
              or vim.fn.getcwd()

            if fname == "" then
              return vim.fn.getcwd()
            end

            local util = require("lspconfig.util")
            return util.root_pattern("Package.swift")(fname)
              or util.root_pattern("buildServer.json")(fname)
              or util.root_pattern("*.xcodeproj", "*.xcworkspace")(fname)
              or util.find_git_ancestor(fname)
          end,
          on_attach = function(client, bufnr)
            -- Sourcekit handles all primary Swift operations
            client.server_capabilities.definitionProvider = true
            client.server_capabilities.typeDefinitionProvider = true
            client.server_capabilities.hoverProvider = true
            client.server_capabilities.renameProvider = true
            client.server_capabilities.codeActionProvider = true
          end,
        },

        -- -- Python LSP (Astral's ty) - Type checking
        -- ty = {
        --   -- cmd = { "/Users/guzman.109/.local/bin/ty", "server" },
        --   filetypes = { "python" },
        --   autostart = true,
        --   root_dir = function(filename)
        --     local util = require("lspconfig.util")
        --     return util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git")(filename)
        --   end,
        --   settings = {
        --     ty = {
        --       -- ty uses same settings structure as pyright
        --       analysis = {
        --         typeCheckingMode = "standard", -- or "strict" for more checks
        --         autoSearchPaths = true,
        --         useLibraryCodeForTypes = true,
        --         diagnosticMode = "workspace", -- or "openFilesOnly" for better performance
        --       },
        --     },
        --   },
        --   on_attach = function(client, bufnr)
        --     -- ty handles type checking and navigation
        --     client.server_capabilities.definitionProvider = true
        --     client.server_capabilities.typeDefinitionProvider = true
        --     client.server_capabilities.hoverProvider = true
        --     client.server_capabilities.renameProvider = true
        --     client.server_capabilities.referencesProvider = true
        --     client.server_capabilities.documentSymbolProvider = true
        --
        --     -- Buffer-local keymaps for ty
        --     local opts = { buffer = bufnr, silent = true }
        --     vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        --     vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        --     vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        --     vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        --   end,
        -- },
        --
        -- -- Ruff LSP - Linting and formatting
        -- ruff = {
        --   -- cmd = { "/Users/guzman.109/.local/bin/ruff", "server" },
        --   filetypes = { "python" },
        --   autostart = true,
        --   root_dir = function(filename)
        --     local util = require("lspconfig.util")
        --     return util.root_pattern("pyproject.toml", "ruff.toml", ".ruff.toml", "setup.py", ".git")(filename)
        --   end,
        --   init_options = {
        --     settings = {
        --       -- Ruff settings
        --       args = {
        --         -- Add any ruff-specific arguments here
        --       },
        --       lint = {
        --         enable = true,
        --         preview = false, -- Enable preview rules if you want cutting-edge checks
        --       },
        --       format = {
        --         enable = true,
        --         preview = false,
        --       },
        --     },
        --   },
        --   on_attach = function(client, bufnr)
        --     -- Ruff handles linting and formatting, but not type checking
        --     client.server_capabilities.hoverProvider = false -- Let ty handle hover
        --     client.server_capabilities.definitionProvider = false -- Let ty handle navigation
        --     client.server_capabilities.referencesProvider = false -- Let ty handle references
        --     client.server_capabilities.renameProvider = false -- Let ty handle renames
        --
        --     -- Ruff handles these
        --     client.server_capabilities.documentFormattingProvider = true
        --     client.server_capabilities.documentRangeFormattingProvider = true
        --     client.server_capabilities.codeActionProvider = true -- For quick fixes
        --
        --     -- Set up format on save with ruff
        --     vim.api.nvim_create_autocmd("BufWritePre", {
        --       buffer = bufnr,
        --       callback = function()
        --         vim.lsp.buf.format({
        --           async = false,
        --           filter = function(c)
        --             return c.name == "ruff"
        --           end,
        --         })
        --       end,
        --     })
        --
        --     -- Keymaps for ruff actions
        --     local opts = { buffer = bufnr, silent = true }
        --     vim.keymap.set("n", "<leader>cf", function()
        --       vim.lsp.buf.format({ name = "ruff" })
        --     end, opts)
        --   end,
        -- },
        --
        -- -- Zig LSP
        -- zls = {
        --   filetypes = { "zig" },
        --   autostart = true,
        --   root_dir = function(filename)
        --     local util = require("lspconfig.util")
        --     return util.root_pattern("zls.json", "build.zig", ".git")(filename)
        --   end,
        --   settings = {
        --     zls = {
        --       enable_autofix = true,
        --       enable_snippets = true,
        --       warn_style = true,
        --     },
        --   },
        --   on_attach = function(client, bufnr)
        --     -- zls handles all primary Zig operations
        --     client.server_capabilities.definitionProvider = true
        --     client.server_capabilities.typeDefinitionProvider = true
        --     client.server_capabilities.hoverProvider = true
        --     client.server_capabilities.renameProvider = true
        --     client.server_capabilities.codeActionProvider = true
        --   end,
        -- },
      },
    },
    init = function()
      -- Optimized diagnostic config
      vim.diagnostic.config({
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      -- Enhanced diagnostic highlights
      vim.cmd([[
        highlight DiagnosticError guifg=#ff0000 gui=bold
        highlight DiagnosticWarn guifg=#ffa500 gui=bold
        highlight DiagnosticInfo guifg=#00ffff
        highlight DiagnosticHint guifg=#808080 gui=italic
      ]])

      -- Performance optimization
      vim.lsp.set_log_level("warn")

      -- Language-specific optimizations
      local function setup_language_priority(pattern, primary_lsp)
        vim.api.nvim_create_autocmd("FileType", {
          pattern = pattern,
          callback = function(args)
            vim.defer_fn(function()
              local clients = vim.lsp.get_clients({ bufnr = args.buf })
              local primary_attached = false

              for _, client in ipairs(clients) do
                if client.name == primary_lsp then
                  primary_attached = true
                  break
                end
              end

              if not primary_attached then
                vim.cmd("LspStart " .. primary_lsp)
              end
            end, 100)
          end,
        })
      end

      -- Set up priority for each language
      setup_language_priority("swift", "sourcekit")
      -- setup_language_priority("python", "ty")
      -- setup_language_priority("zig", "zls")

      -- File-specific optimizations
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = { "*.swift", "*.py", "*.zig" },
        callback = function()
          vim.opt_local.updatetime = 300 -- Faster LSP updates
        end,
      })

      -- Python-specific settings for ty
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*.py",
        callback = function()
          vim.opt_local.tabstop = 4
          vim.opt_local.shiftwidth = 4
          vim.opt_local.expandtab = true
        end,
      })

      -- Zig-specific settings
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*.zig",
        callback = function()
          vim.opt_local.tabstop = 4
          vim.opt_local.shiftwidth = 4
          vim.opt_local.expandtab = true
        end,
      })
    end,
  },
}
