local function datetime()
  local CTimeLine = require("lualine.component"):extend()

  CTimeLine.init = function(self, options)
    CTimeLine.super.init(self, options)
  end

  CTimeLine.update_status = function(self)
    return os.date(self.options.format or "%a %b %d %I:%M %p", os.time())
  end

  return CTimeLine
end

return {
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        -- Bubbles
        component_separators = "",
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
        lualine_z = {
          { datetime(), separator = { right = "" }, left_padding = 2 },
        },
      },
    },
  },
  {
    "Saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "enter",

        ["<Tab>"] = {
          "select_next",
          "snippet_forward",
          "fallback",
        },

        ["<S-Tab>"] = {
          "select_prev",
          "snippet_backward",
          "fallback",
        },

        ["<C-x>"] = { "cancel" }
      },
    },
  },

}
