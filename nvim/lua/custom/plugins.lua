local plugins = {
  -- Use clipboard over ssh
  {
    "ojroques/nvim-osc52",
    event = "VeryLazy",
    config = function()
      require "custom.configs.oscconfig"
    end,
  },
  -- Setterminal dimensions
  {
    "NvChad/nvterm",
    config = function()
      require "custom.configs.nvterm"
    end,
  },
  -- Preview markdown files
  {
    "ellisonleao/glow.nvim",
    event = "VeryLazy",
    config = true,
    cmd = "Glow",
  },
  -- For viewing images in buffers
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
          require("nvim-treesitter.configs").setup {
            ensure_installed = { "markdown" },
            highlight = { enable = true },
          }
        end,
      },
    },
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      kitty_method = "normal",
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.JPG", "*.PNG", "*.JPEG", "*.GIF" },
    },
  },
  -- LSP package manager
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        -- LSP
        "lua-language-server",
        "ruff-lsp",
        "marksman",
        "clangd",
        "cmake-language-server",
        "biome",
        -- Formatters
        "stylua",
        "prettier",
        "ruff",
        "clang-format",
        "cmakelang",
        "mdformat",
        "yamlfix",
        -- Linters
        "mypy",
        "pylint",
        "cmakelint",
        -- Debuggers
        "debugpy",
        "codelldb",
      },
    },
  },

  -- In order to modify the `lspconfig` configuration:
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  -- Formatter
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "ConformInfo" },
    config = function()
      local conform = require "conform"

      conform.setup {
        formatters_by_ft = {
          lua = { "stylua" },
          javascript = { "biome" },
          typescript = { "biome" },
          css = { "prettier" },
          html = { "prettier" },
          markdown = { "mdformat" },
          json = { "biome" },
          yaml = { "yamlfix" },
          cpp = { "clang-format" },
          cmake = { "cmake_format" },
          python = { "ruff_format" },
        },
      }
      vim.keymap.set({ "n", "v" }, "<leader>fm", function()
        conform.format {
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        }
      end, { desc = "Format Current File" })
    end,
  },
  -- Linter
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require "lint"
      lint.linters_by_ft = {
        javascript = { "biomejs" },
        typescript = { "biomejs" },
        json = { "biomejs" },
        python = { "mypy", "pylint" },
        cpp = { "clangtidy" },
        cmake = { "cmakelint" },
      }
      vim.keymap.set("n", "<leader>ll", function()
        lint.try_lint()
      end, { desc = "Lint Current File" })
    end,
  },
  -- For code folding
  {
    "kevinhwang91/nvim-ufo",
    event = "VeryLazy",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      require "custom.configs.ufoconfig"
    end,
  },
  -- Debugger
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    config = function()
      require("core.utils").load_mappings "dap"
    end,
  },
  -- Debugger UI
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  -- Package manager for debugger
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    event = "VeryLazy",
    opts = {
      handles = {},
    },
  },
  {
    "mfussenegger/nvim-dap-python",
    event = "VeryLazy",
    ft = { "python" },
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },

    config = function(_, opts)
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
      require("core.utils").load_mappings "dap_python"
    end,
  },
}
return plugins
