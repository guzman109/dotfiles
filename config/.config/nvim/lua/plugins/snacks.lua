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
      gh = {},
      notifier = {
        style = "compact",
      },
      dashboard = {
        sections = {
          { section = "header" },
          {
            pane = 1,
            section = "terminal",
            cmd = "bash ~/.config/inspiration/quote-cache.sh --box 58",
            height = 5,
            padding = 0,
            ttl = 0,
            icon = "",
            hl = "DiagnosticHint",
            title = os.date("%A, %B %d, %Y"),
          },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 2 },
          {
            icon = " ",
            title = "Recent Files",
            section = "recent_files",
            indent = 2,
            padding = 2,
            limit = 5,
          },
          {
            icon = " ",
            title = "Projects",
            section = "projects",
            indent = 2,
            padding = 2,
            limit = 5,
          },
          { section = "startup", pane = 1 },
        },
      },
      dim = {},
      git = {},
      keymap = {},
      image = {},
      indent = {},
      rename = {},
      words = {},
    },
  },
}
