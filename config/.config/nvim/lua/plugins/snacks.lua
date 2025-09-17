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
      dashboard = {
        sections = {
          { section = "header" },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
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
