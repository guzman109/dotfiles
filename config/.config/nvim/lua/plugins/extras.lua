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
}
