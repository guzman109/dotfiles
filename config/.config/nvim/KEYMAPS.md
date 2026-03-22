# ClaudlosVim Keymaps

## General
| Key | Action | File |
|-----|--------|------|
| `<leader>w` | Save | 00-core |
| `<leader>q` | Quit | 00-core |
| `<Esc>` | Clear search highlight | 00-core |
| `<A-j>` / `<A-k>` | Move line up/down | 00-core |
| `<` / `>` (visual) | Indent and keep selection | 00-core |
| `<Esc><Esc>` (terminal) | Exit terminal mode | 00-core |

## Navigation
| Key | Action | File |
|-----|--------|------|
| `<C-h/j/k/l>` | Move between splits | 00-core |
| `<S-h>` / `<S-l>` | Previous / next tab | 00-core |
| `<leader>tn` | New tab | 00-core |
| `<leader>tc` | Close tab | 00-core |
| `-` / `<leader>e` | File explorer (oil) | editor-tools |

## Finder (fzf-lua)
| Key | Action | File |
|-----|--------|------|
| `<leader><space>` / `ff` | Find files | editor-finder |
| `<leader>/` | Live grep | editor-finder |
| `<leader>fb` | Buffers | editor-finder |
| `<leader>fh` | Help tags | editor-finder |
| `<leader>fr` | Recent files | editor-finder |
| `<leader>fd` | Diagnostics | editor-finder |
| `<leader>fs` | Document symbols | editor-finder |

## Harpoon
| Key | Action | File |
|-----|--------|------|
| `<leader>ha` | Add file to harpoon | editor-tools |
| `<leader>hh` | Harpoon quick menu | editor-tools |
| `<leader>1` | Jump to harpoon file 1 | editor-tools |
| `<leader>2` | Jump to harpoon file 2 | editor-tools |
| `<leader>3` | Jump to harpoon file 3 | editor-tools |
| `<leader>4` | Jump to harpoon file 4 | editor-tools |

## LSP (only when server attached)
| Key | Action | File |
|-----|--------|------|
| `gd` | Go to definition | 00-core |
| `gD` | Go to declaration | 00-core |
| `gr` | References | 00-core |
| `gi` | Implementation | 00-core |
| `K` | Hover docs | 00-core |
| `<leader>cr` | Rename symbol | 00-core |
| `<leader>ca` | Code action | 00-core |
| `<leader>cs` | Signature help | 00-core |
| `<C-s>` (insert) | Signature help | 00-core |
| `<leader>cf` | Format | 00-core |
| `<leader>cd` | Line diagnostics | 00-core |
| `]d` / `[d` | Next / prev diagnostic | 00-core |

## Git
| Key | Action | File |
|-----|--------|------|
| `]h` / `[h` | Next / prev hunk | editor-git |
| `<leader>gs` | Stage hunk | editor-git |
| `<leader>gr` | Reset hunk | editor-git |
| `<leader>gS` | Stage buffer | editor-git |
| `<leader>gu` | Undo stage hunk | editor-git |
| `<leader>gp` | Preview hunk | editor-git |
| `<leader>gb` | Blame line | editor-git |
| `<leader>gd` | Diff this | editor-git |

## DAP (Debug)
| Key | Action | File |
|-----|--------|------|
| `<leader>db` | Toggle breakpoint | editor-tools |
| `<leader>dB` | Conditional breakpoint | editor-tools |
| `<leader>dc` | Continue | editor-tools |
| `<leader>di` | Step into | editor-tools |
| `<leader>do` | Step over | editor-tools |
| `<leader>dO` | Step out | editor-tools |
| `<leader>dr` | Restart | editor-tools |
| `<leader>dt` | Terminate | editor-tools |
| `<leader>du` | Toggle DAP UI | editor-tools |
| `<leader>de` | Eval under cursor | editor-tools |

## AI (CodeCompanion)
| Key | Action | File |
|-----|--------|------|
| `<leader>ai` | AI Chat | editor-tools |
| `<leader>aa` | AI Actions | editor-tools |

## Surround (mini.surround)
| Key | Action | File |
|-----|--------|------|
| `sa` | Add surround | 01-mini |
| `sd` | Delete surround | 01-mini |
| `sr` | Replace surround | 01-mini |

## Folding (ufo)
| Key | Action | File |
|-----|--------|------|
| `zR` | Open all folds | editor-tools |
| `zM` | Close all folds | editor-tools |
| `zK` | Peek fold | editor-tools |

## Python
| Key | Action | File |
|-----|--------|------|
| `<leader>pv` | Select venv | lang-python |
| `<leader>pc` | Cached venv | lang-python |
| `<leader>pr` | Run file | lang-python |
| `<leader>dm` | Debug test method | lang-python |
| `<leader>dk` | Debug test class | lang-python |

## C/C++
| Key | Action | File |
|-----|--------|------|
| `<leader>ch` | Switch header/source | lang-cpp |
| `<leader>cb` | Build (cmake/make/meson) | lang-cpp |

## Zig
| Key | Action | File |
|-----|--------|------|
| `<leader>zb` | Zig build | lang-zig |
| `<leader>zt` | Zig test | lang-zig |
| `<leader>zr` | Zig run file | lang-zig |

## HTTP (kulala)
| Key | Action | File |
|-----|--------|------|
| `<leader>hr` | Run request | lang-http |
| `<leader>ha` | Run all requests | lang-http |
| `<leader>hn` | Next request | lang-http |
| `<leader>hp` | Prev request | lang-http |
| `<leader>he` | Select environment | lang-http |
| `<leader>hc` | Copy as cURL | lang-http |

## Lua
| Key | Action | File |
|-----|--------|------|
| `<leader>lx` | Source current file | lang-lua |
