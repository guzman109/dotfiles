local plugins = {
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
    opts = function()
      return require "custom.configs.mason"
    end,
  },

  -- In order to modify the `lspconfig` configuration:
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  -- Formatter & Linter
  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    opts = function()
      return require "custom.configs.nonels"
    end,
  },
  -- -- Formatter
  -- {
  --   "stevearc/conform.nvim",
  --   event = { "BufReadPre", "BufNewFile" },
  --   cmd = { "ConformInfo" },
  --   config = function()
  --     require "custom.configs.conform"
  --   end,
  -- },
  -- -- Linter
  -- {
  --   "mfussenegger/nvim-lint",
  --   event = { "BufReadPre", "BufNewFile" },
  --   config = function()
  --     require "custom.configs.lint"
  --   end,
  -- },
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
    config = function()
      require("core.utils").load_mappings "dap"
    end,
  },
  -- Debugger UI
  {
    "rcarriga/nvim-dap-ui",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      require "custom.configs.dapui"
    end,
  },

  -- Package manager for debugger
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handles = {},
    },
  },
  {
    "mfussenegger/nvim-dap-python",
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
  -- Scorlling through files
  {
    "stevearc/aerial.nvim",
    event = "VeryLazy",
    opts = {},
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
}
return plugins
