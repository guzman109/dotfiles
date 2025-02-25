return {
  {
    "zaldih/themery.nvim",
    config = function()
      require("themery").setup({
        themes = {
          "catppuccin-mocha",
          "catppuccin-latte",
          "catppuccin-frappe",
          "catppuccin-macchiato",
          "tokyonight-storm",
          "tokyonight-night",
          "tokyonight-moon",
          "tokyonight-day",
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
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-latte",
    },
  },
}
