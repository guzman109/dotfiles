---@type ChadrcConfig
local M = {}

-- Key mappings
M.mappings = require "custom.mappings"

-- Plugins
M.plugins = "custom.plugins"

-- Themes
M.ui = { 
  theme = 'tokyonight',
  transparency = true,
  theme_toggle = {"tokyonight", "github_light"},
  statusline = {
    theme = "minimal"
  }
}

return M
