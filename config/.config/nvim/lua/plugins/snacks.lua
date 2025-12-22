return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      animate = {
        -- enabled = true,
        fps = 120,
        easing = "elastic",
      },
      bufdelete = {},
      notifier = {
        style = "compact",
      },
      styles = {
        notification = {
          wo = { winblend = 0 },
          border = "rounded",
        },
      },
      dashboard = {
        sections = {
          {
            section = "header",
          },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 2 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 2, limit = 5 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2, limit = 5 },
          { section = "startup" },
        },
      },

      dim = {},
      git = {},
      image = {},
      indent = {},
      rename = {},
      words = {},
    },
  },
}
