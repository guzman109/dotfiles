---@type ChadrcConfig
local M = {}

-- Key mappings
M.mappings = require "custom.mappings"

-- Plugins
M.plugins = "custom.plugins"

-- Themes
M.ui = {
  theme = 'catppuccin',
  transparency = true,
  theme_toggle = {"catppuccin", "catppuccin-latte"},
  statusline = {
    theme = "minimal"
  }
}

return M
