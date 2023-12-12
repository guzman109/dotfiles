package.path = package.path .. ";" .. vim.fn.expand "$HOME" .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand "$HOME" .. "/.luarocks/share/lua/5.1/?.lua;"
---@type ChadrcConfig
local M = {}

-- Key mappings
M.mappings = require "custom.mappings"

-- Plugins
M.plugins = "custom.plugins"

-- Themes
M.ui = {
  theme = "catppuccin",
  transparency = false,
  theme_toggle = { "catppuccin", "catppuccin-latte" },
  statusline = {
    theme = "default",
  },
  nvdash = {
    load_on_startup = true,
  },
  cheatsheet = {
    theme = "simple",
  },
}

return M
