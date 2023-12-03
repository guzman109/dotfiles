package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"
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
  theme_toggle = {"tokyonight", "catppuccin-latte"},
  statusline = {
    theme = "minimal"
  }
}

return M
