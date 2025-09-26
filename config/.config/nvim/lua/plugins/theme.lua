-- stylua= ignore
local colors = {
  blue = "#80a0ff",
  cyan = "#79dac8",
  black = "#080808",
  white = "#c6c6c6",
  red = "#ff5189",
  violet = "#d183e8",
  grey = "#303030",
}

local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.violet },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.white },
  },

  insert = { a = { fg = colors.black, bg = colors.blue } },
  visual = { a = { fg = colors.black, bg = colors.cyan } },
  replace = { a = { fg = colors.black, bg = colors.red } },

  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.white },
  },
}
return {
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

      -- im.keymap.set(),
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
  },
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   event = "VeryLazy",
  --   opts = function()
  --     return {
  --       options = {
  --         -- theme = bubbles_theme,
  --         component_separators = "",
  --         section_separators = { left = "", right = "" },
  --       },
  --       sections = {
  --         lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
  --         lualine_b = { "filename", "branch" },
  --         lualine_c = {
  --           "%=", --[[ add your center compoentnts here in place of this comment ]]
  --         },
  --         lualine_x = {},
  --         lualine_y = { "filetype", "progress" },
  --         lualine_z = {
  --           { "location", separator = { right = "" }, left_padding = 2 },
  --         },
  --       },
  --       inactive_sections = {
  --         lualine_a = { "filename" },
  --         lualine_b = {},
  --         lualine_c = {},
  --         lualine_x = {},
  --         lualine_y = {},
  --         lualine_z = { "location" },
  --       },
  --       tabline = {},
  --       extensions = {},
  --     }
  --   end,
  -- },
}
