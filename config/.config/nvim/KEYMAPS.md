# AgentVim Keymaps

> Leader: `<Space>` | LocalLeader: `<Space>`

## General

| Key | Mode | Action |
|-----|------|--------|
| `<C-s>` | n | Save |
| `<Esc>` | n | Clear search highlight |
| `j` / `k` | n | Wrap-aware movement when no count is used |
| `<` / `>` | v | Indent selection and keep it selected |
| `<Esc><Esc>` | t | Exit terminal mode |
| `q` | n | Close quick/help-style buffers |

## Windows, Tabs, Terminal

| Key | Mode | Action |
|-----|------|--------|
| `<C-h/j/k/l>` | n | Move between splits |
| `<leader>wv` / `<leader>ws` | n | Vertical / horizontal split |
| `<leader>wd` / `<leader>wo` | n | Close split / close other splits |
| `<leader>w=` / `<leader>wT` | n | Equalize splits / move split to tab |
| `<leader>w+` / `<leader>w-` | n | Increase / decrease split height |
| `<leader>w>` / `<leader>w<` | n | Increase / decrease split width |
| `<leader>wH` / `<leader>wV` | n | Set split to half height / half width |
| `<S-h>` / `<S-l>` | n | Previous / next tab |
| `<leader>tn` / `<leader>tc` | n | New / close tab |
| `<leader>to` / `<leader>tr` | n | Close other tabs / close tabs to right |
| `<leader>t<` / `<leader>t>` | n | Move tab left / right |
| `<leader>tt` | n | Terminal in small bottom split |
| `<leader>tT` / `<leader>tv` / `<leader>ts` | n | Terminal in tab / vsplit / split |

## Project

| Key | Mode | Action |
|-----|------|--------|
| `<leader>pp` | n | Pick and run a `just` recipe |
| `<leader>pe` | n | Edit nearest `justfile` |
| `<leader>pI` | n | Initialize project files |
| `<leader>pv` | n | Select Python venv, only in Python contexts |
| `<leader>pV` | n | Activate cached Python venv, only in Python contexts |
| `<leader>pX` | n | Deactivate Python venv, only in Python contexts |
| `<leader>pP` | n | Show active Python, only in Python contexts |

## Neovim Config

| Key | Mode | Action |
|-----|------|--------|
| `<leader>Ni` | n | Edit `init.lua` |
| `<leader>Nk` | n | Open keymaps docs |
| `<leader>Nc` | n | Open commands docs |
| `<leader>Nu` | n | Update plugins |
| `<leader>Nx` | n | Clean inactive plugins |
| `<leader>Nr` | n | Restart Neovim |
| `<leader>Nq` | n | Quit Neovim |

## Code And LSP

| Key | Mode | Action |
|-----|------|--------|
| `<leader>cf` | n | Format current buffer |
| `<leader>cd` | n | Line diagnostics |
| `[d` / `]d` | n | Previous / next diagnostic |
| `<leader>co` | n | Toggle code outline |
| `<leader>cl` | n | Show C/C++ class layout |
| `gd` / `gD` | n | Go to definition / declaration |
| `gr` / `gi` | n | References / implementations |
| `K` | n | Hover |
| `<leader>cr` | n | Rename symbol |
| `<leader>ca` | n/x | Code action |
| `<leader>cs` | n/i | Signature help |
| `<leader>ci` | n | Toggle inlay hints |
| `<leader>cL` | n | Run codelens |

## Trouble

| Key | Mode | Action |
|-----|------|--------|
| `<leader>xx` | n | Workspace diagnostics |
| `<leader>xX` | n | Buffer diagnostics |
| `<leader>xs` | n | Document symbols |
| `<leader>xl` | n | LSP definitions, references, implementations |
| `<leader>xL` | n | Location list |
| `<leader>xQ` | n | Quickfix list |
| `<C-t>` | fzf-lua | Open picker results in Trouble |

## Finder

| Key | Mode | Action |
|-----|------|--------|
| `<leader><space>` / `ff` | n | Find files |
| `<leader>/` | n | Live grep |
| `<leader>b` / `<leader>fb` | n | Buffers |
| `<leader><Tab>` | n | Alternate buffer |
| `<leader>fh` / `<leader>fr` | n | Help / recent files |
| `<leader>fd` | n | Diagnostics |
| `<leader>fs` / `<leader>fS` | n | Document / workspace symbols |
| `<leader>fg` / `<leader>fl` / `<leader>fL` | n | Git status / log / buffer log |
| `<leader>fT` | n | Project TODOs and code markers |
| `<leader>fw` | n/v | Grep word / selection |
| `<leader>fm` / `<leader>fR` / `<leader>fK` | n | Marks / registers / keymaps |
| `<leader>ft` | n | Resume last picker |

## Files

| Key | Mode | Action |
|-----|------|--------|
| `-` / `<leader>e` | n | Open Oil |
| `<leader>E` | n | Open Oil in a new tab |
| `q` | n | Return from Oil to previous buffer |
| `<leader>ha` / `<leader>hd` / `<leader>hc` | n | Harpoon add / remove current / clear |
| `<leader>hh` | n | Harpoon menu |
| `<leader>1`-`<leader>4` | n | Jump to Harpoon item |
| `<C-S-P>` / `<C-S-N>` | n | Harpoon previous / next |

## Git

| Key | Mode | Action |
|-----|------|--------|
| `]h` / `[h` | n | Next / previous hunk |
| `<leader>gs` / `<leader>gr` | n | Stage / reset hunk |
| `<leader>gS` / `<leader>gu` | n | Stage buffer / undo staged hunk |
| `<leader>gp` / `<leader>gb` / `<leader>gd` | n | Preview hunk / blame line / diff this |
| `<leader>gg` | n | Lazygit in a tab |

## Debug

| Key | Mode | Action |
|-----|------|--------|
| `<leader>db` / `<leader>dB` | n | Toggle / conditional breakpoint |
| `<leader>dc` / `<leader>dr` / `<leader>dt` | n | Continue / restart / terminate |
| `<leader>di` / `<leader>do` / `<leader>dO` | n | Step into / over / out |
| `<leader>du` | n | Toggle DAP UI |
| `<leader>de` | n/v | Eval under cursor / selection |

## Media And Preview

| Key | Mode | Action |
|-----|------|--------|
| `<leader>mp` / `<leader>ms` / `<leader>mf` | n | Live preview start / stop / pick |

## HTTP

| Key | Mode | Action |
|-----|------|--------|
| `<leader>kr` | n/v | Run current Kulala request |
| `<leader>kR` | n | Show Kulala script output |
| `<leader>ke` | n | Select Kulala environment |

## AI

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ac` | n | Open or focus AI agent |
| `<leader>an` | n | New AI agent tab |
| `<leader>af` | n | Add current file to last AI session |

## Builtins

| Key | Mode | Action |
|-----|------|--------|
| `zR` / `zM` / `zK` | n | Open folds / close folds / peek fold |
| `sa` / `sd` / `sr` | n/v | Add / delete / replace surround |
