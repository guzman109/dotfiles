local M = {}

M.base_30 = {
  white = "#8839ef", -- Cursor Line Nr,
  darker_black = "#e6e9ef", --Float BG, NvimTree BG
  black = "#eff1f5", -- Nvim BG, Pmenu FG, Nvim Internal Error FG, Lazy H1 FG
  black2 = "#e6e9ef", -- Tabline BG
  one_bg = "#ccd0da", --Pmenu BG, Lazy Button BG
  one_bg2 = "#acb0be", -- inactive tab BG, Highligh of context
  one_bg3 = "#bcc0cc", -- Vim Mode
  grey = "#9ca0b0", -- Pemnu Thumb, Line Nr,
  grey_fg = "#8c8fa1", -- Comments
  grey_fg2 = "#7c7f93",
  light_grey = "#5c5f77", -- Lazy Button FG, Mode FG
  red = "#e64553", -- Nvim Internal Error, Lazy H2 FG
  baby_pink = "#dd7878",
  pink = "#ea76cb", -- Lazy commit issue
  line = "#acb0be", --Window Separator
  green = "#40a02b", -- Health Success BG, Lazy H1 FG
  vibrant_gree = "#179299",
  nord_blue = "#303446", -- active tab bg
  blue = "#1e66f5", -- Float Boarder
  yellow = "#df8e1d",
  sun = "#df8e1d",
  purple = "#8839ef", -- Lazy Reason ft
  dark_purple = "#dd7878",
  teal = "#179299", -- Lazy Value
  orange = "#fe640b",
  cyan = "#209fb5", -- Visual Mode
  statusline_bg = "#dce0e8", -- Status line BG
  -- lightbg = "#dc322f", --
  pmenu_bg = "#7c7f93", -- Pmenu Select BG
  folder_bg = "#4C4F69", -- nvim tree folders color
}

-- https://github.com/catppuccin/base16
M.base_16 = {
  base00 = "#eff1f5", -- Default Background
  base01 = "#e6e9ef", -- Lighter Background (Used for status bars, line number and folding marks)
  base02 = "#ccd0da", -- Selection Background
  base03 = "#bcc0cc", -- Comments, Invisibles, Line Highlighting
  base04 = "#acb0be", -- Dark Foreground (Used for status bars)
  base05 = "#4c4f69", -- Default Foreground, Caret, Delimiters, Operators
  base06 = "#dc8a78", -- Light Foreground (Not often used)
  base07 = "#7287fd", -- Light Background (Not often used)
  base08 = "#d20f39", -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  base09 = "#fe640b", -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
  base0A = "#df8e1d", -- Classes, Markup Bold, Search Text Background
  base0B = "#40a02b", -- Strings, Inherited Class, Markup Code, Diff Inserted
  base0C = "#179299", -- Support, Regular Expressions, Escape Characters, Markup Quotes
  base0D = "#1e66f5", -- Functions, Methods, Attribute IDs, Headings
  base0E = "#8839ef", -- Keywords, Storage, Selector, Markup Italic, Diff Changed
  base0F = "#dd7878", -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
}

M.type = "light"

return M

