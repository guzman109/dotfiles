return {
  { -- was missing this
    "catppuccin/nvim",
    name = "catppuccin",
    opts = function(_, opts)
      local module = require("catppuccin.groups.integrations.bufferline")
      if module then
        module.get = module.get_theme
      end
      return opts
    end,
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
}
