return {
  {
    "Pocco81/auto-save.nvim",
    lazy = false,
    opts = {
      debounce_delay = 100,
      execution_message = {
        message = function()
          return ""
        end,
      },
    },
    keys = {
      { "<leader>uv", "<cmd>ASToggle<CR>", desc = "Toggle autosave" },
    },
  },
  {
   "amitds1997/remote-nvim.nvim",
   version = "*", -- Pin to GitHub releases
   dependencies = {
       "nvim-lua/plenary.nvim", -- For standard functions
       "MunifTanjim/nui.nvim", -- To build the plugin UI
       -- "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
   },
   config = true,
}
}
