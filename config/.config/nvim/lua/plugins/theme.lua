return {
  {
    "catppuccin/nvim",
    opts = {
      flavour = "auto", -- latte, frappe, macchiato, mocha
      background = { -- :h background
        light = "latte",
        dark = "mocha",
      },
      -- transparent_background = true,
      -- float = {
      --   transparent = true,
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
        -- operators = { "bold" },
        -- miscs = {},
      },
      integrations = { blink_cmp = true },
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
}
