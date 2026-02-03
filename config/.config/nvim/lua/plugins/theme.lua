return {
  {
    "catppuccin/nvim",
    opts = {
      flavour = "auto", -- latte, frappe, macchiato, mocha
      background = { -- :h background
        light = "latte",
        dark = "mocha",
      },
      transparent_background = true,
      float = {
        transparent = true,
        solid = false,
      },
      show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
      term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
      -- dim_inactive = {
      --   enabled = true, -- dims the background color of inactive window
      --   shade = "dark",
      --   percentage = 0.15, -- percentage of the shade to apply to the inactive window
      -- },
      -- no_italic = true,
      styles = {
        comments = {
          "bold",
          "italic",
        },
        keywords = {
          "italic",
          "bold",
        },
        functions = { "italic" },
        loops = { "italic" },
        properties = { "bold" },
        types = { "italic", "bold" },
        operators = { "bold" },
        -- miscs = {},
      },
      integrations = {
        aerial = true,
        blink_cmp = true,
        lsp_trouble = true,
        mason = true,
        noice = true,
        overseer = true,
        snacks = {
          enabled = true,
        },
        which_key = true,
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      transparent = false,
      styles = {
        keywords = { bold = true },
        functions = { bold = true },
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.icons = {
        rules = {
          { pattern = "themes", icon = LazyVim.config.icons.kinds.Color, color = "orange" },
        },
      }
    end,
  },
  {
    "zaldih/themery.nvim",
    config = function()
      require("themery").setup({
        themes = {
          { name = "Catppuccin Mocha", colorscheme = "catppuccin-mocha" },
          { name = "Catppuccin Latte", colorscheme = "catppuccin-latte" },
          { name = "Catppuccin Frappé", colorscheme = "catppuccin-frappe" },
          { name = "Catppuccin Macchiato", colorscheme = "catppuccin-macchiato" },
          { name = "Tokyo Night Storm", colorscheme = "tokyonight-storm" },
          { name = "Tokyo Night OG", colorscheme = "tokyonight-night" },
          { name = "Tokyo Night Moon", colorscheme = "tokyonight-moon" },
          { name = "Tokyo Night Day", colorscheme = "tokyonight-day" },
        }, -- Your list of installed colorschemes
        livePreview = true, -- Apply theme while browsing. Default to true.
      })
      vim.keymap.set({ "n", "v" }, "<leader>tt", "<cmd>Themery<cr>", { desc = "Open Themes" })
      vim.keymap.set({ "n", "v" }, "<leader>td", "<cmd>colorscheme catppuccin-latte<cr>", { desc = "Day Theme" })
      vim.keymap.set({ "n", "v" }, "<leader>tn", "<cmd>colorscheme catppuccin-mocha<cr>", { desc = "Night Theme" })
      vim.keymap.set("n", "<leader>ta", function()
        local themery = require("themery")
        local currentTheme = themery.getCurrentTheme()
        if currentTheme and currentTheme.name == "catppuccin-latte" then
          themery.setThemeByName("catppuccin-mocha", true)
        else
          themery.setThemeByName("catppuccin-latte", true)
        end
      end, { noremap = true })

      -- im.keymap.set(),
    end,
  },
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.api.nvim_set_option_value("background", "dark", {})
        vim.cmd("colorscheme catppuccin-mocha")
      end,
      set_light_mode = function()
        vim.api.nvim_set_option_value("background", "light", {})
        vim.cmd("colorscheme catppuccin-latte")
      end,
    },
  },
  -- Indent guides for better code structure visibility
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "LazyFile",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },
  -- Show context of current function/class at top of window
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "LazyFile",
    opts = {
      max_lines = 3,
      multiline_threshold = 1,
      trim_scope = "outer",
      mode = "cursor",
      separator = "─",
    },
  },
}
