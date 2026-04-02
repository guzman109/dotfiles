# ClaudlosVim Keymaps

> Leader: `<Space>` | LocalLeader: `<Space>`

## General

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<C-s>` | n | Save | 20_keymaps |
| `<Esc>` | n | Clear search highlight | 20_keymaps |
| `j` / `k` | n | Smart visual line movement (no count) | 20_keymaps |
| `<A-j>` | n | Move line down | 20_keymaps |
| `<A-k>` | n | Move line up | 20_keymaps |
| `<A-j>` | v | Move selection down | 20_keymaps |
| `<A-k>` | v | Move selection up | 20_keymaps |
| `<` | v | Indent left and keep selection | 20_keymaps |
| `>` | v | Indent right and keep selection | 20_keymaps |
| `<Esc><Esc>` | t | Exit terminal mode | 20_keymaps |
| `q` | n | Close (help, man, qf, checkhealth, dap-float) | 20_keymaps |

## Navigation

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<C-h>` | n | Go to left split | 20_keymaps |
| `<C-j>` | n | Go to lower split | 20_keymaps |
| `<C-k>` | n | Go to upper split | 20_keymaps |
| `<C-l>` | n | Go to right split | 20_keymaps |

## Tabs

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<S-h>` | n | Previous tab | 20_keymaps |
| `<S-l>` | n | Next tab | 20_keymaps |
| `<leader>tn` | n | New tab | 20_keymaps |
| `<leader>tc` | n | Close tab | 20_keymaps |
| `<leader>to` | n | Close other tabs | 20_keymaps |
| `<leader>tr` | n | Close tabs to right | 20_keymaps |
| `<leader>t<` | n | Move tab left | 20_keymaps |
| `<leader>t>` | n | Move tab right | 20_keymaps |

## Terminal

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>tt` | n | Toggle terminal (bottom split) | 20_keymaps |
| `<leader>tT` | n | Terminal (new tab) | 20_keymaps |
| `<leader>tv` | n | Terminal (vsplit) | 20_keymaps |
| `<leader>ts` | n | Terminal (split) | 20_keymaps |

## Windows / Splits

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>wv` | n | Split vertical | 20_keymaps |
| `<leader>ws` | n | Split horizontal | 20_keymaps |
| `<leader>wd` | n | Close split | 20_keymaps |
| `<leader>wo` | n | Close other splits | 20_keymaps |
| `<leader>w=` | n | Equalize splits | 20_keymaps |
| `<leader>wT` | n | Split to tab | 20_keymaps |

## LSP (only when server attached)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `gd` | n | Go to definition | 20_keymaps |
| `gD` | n | Go to declaration | 20_keymaps |
| `gr` | n | References | 20_keymaps |
| `gi` | n | Implementation | 20_keymaps |
| `K` | n | Hover docs | 20_keymaps |
| `<leader>cr` | n | Rename symbol | 20_keymaps |
| `<leader>ca` | n | Code action | 20_keymaps |
| `<leader>cs` | n | Signature help | 20_keymaps |
| `<leader>ci` | n | Toggle inlay hints | 20_keymaps |
| `<C-s>` | i | Signature help | 20_keymaps |

## Code

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>cf` | n | Format (conform) | 20_keymaps |
| `<leader>cd` | n | Line diagnostics | 20_keymaps |
| `<leader>co` | n | Code outline (aerial) | 50_editor |
| `<leader>cS` | n | Symbol structure (fluoride) | 50_editor |
| `{` | n | Prev symbol (aerial) | 50_editor |
| `}` | n | Next symbol (aerial) | 50_editor |
| `]d` | n | Next diagnostic | 20_keymaps |
| `[d` | n | Prev diagnostic | 20_keymaps |

## Finder (fzf-lua)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader><space>` | n | Find files | 50_editor |
| `ff` | n | Find files | 50_editor |
| `<leader>/` | n | Live grep | 50_editor |
| `<leader>fb` | n | Buffers | 50_editor |
| `<leader>fh` | n | Help tags | 50_editor |
| `<leader>fr` | n | Recent files | 50_editor |
| `<leader>fd` | n | Diagnostics | 50_editor |
| `<leader>fs` | n | Document symbols | 50_editor |
| `<leader>fk` | n | Open keymaps file | 20_keymaps |
| `<leader>fc` | n | Open commands file | 20_keymaps |

## File Explorer (fzf-lua)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `-` | n | Browse parent directory | 50_editor |
| `<leader>e` | n | Browse current file's directory | 50_editor |

## Harpoon

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>ha` | n | Add file to harpoon | 50_editor |
| `<leader>hd` | n | Remove current file | 50_editor |
| `<leader>hh` | n | Harpoon menu (fzf) | 50_editor |
| `<leader>1` | n | Jump to harpoon file 1 | 50_editor |
| `<leader>2` | n | Jump to harpoon file 2 | 50_editor |
| `<leader>3` | n | Jump to harpoon file 3 | 50_editor |
| `<leader>4` | n | Jump to harpoon file 4 | 50_editor |
| `<C-S-P>` | n | Harpoon prev | 50_editor |
| `<C-S-N>` | n | Harpoon next | 50_editor |
| `<C-v>` | n | Open in vsplit (in harpoon quick menu) | 50_editor |
| `<C-x>` | n | Open in split (in harpoon quick menu) | 50_editor |
| `<C-t>` | n | Open in new tab (in harpoon quick menu) | 50_editor |

## Yeet (Command Runner)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>yy` | n | Yeet (repeat last command) | 50_editor |
| `<leader>yl` | n | Yeet command list | 50_editor |
| `<leader>yn` | n | Yeet new command | 50_editor |
| `<leader>yt` | n | Yeet select target | 50_editor |
| `<leader>yq` | n | Yeet interrupt & run | 50_editor |

## Folding (ufo)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `zR` | n | Open all folds | 50_editor |
| `zM` | n | Close all folds | 50_editor |
| `zK` | n | Peek fold (falls back to hover) | 50_editor |

## Git (gitsigns)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `]h` | n | Next hunk | 50_editor |
| `[h` | n | Prev hunk | 50_editor |
| `<leader>gs` | n | Stage hunk | 50_editor |
| `<leader>gr` | n | Reset hunk | 50_editor |
| `<leader>gS` | n | Stage buffer | 50_editor |
| `<leader>gu` | n | Undo stage hunk | 50_editor |
| `<leader>gp` | n | Preview hunk | 50_editor |
| `<leader>gb` | n | Blame line (full) | 50_editor |
| `<leader>gd` | n | Diff this | 50_editor |

## Testing (neotest)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>nr` | n | Run nearest test | 50_editor |
| `<leader>nf` | n | Run file tests | 50_editor |
| `<leader>nA` | n | Run all tests (suite) | 50_editor |
| `<leader>nd` | n | Debug nearest test | 50_editor |
| `<leader>ns` | n | Stop test | 50_editor |
| `<leader>nl` | n | Run last test | 50_editor |
| `<leader>no` | n | Show test output | 50_editor |
| `<leader>nO` | n | Toggle output panel | 50_editor |
| `<leader>nv` | n | Toggle test summary | 50_editor |

## Live Preview

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>mp` | n | Start live preview (browser) | 50_editor |
| `<leader>ms` | n | Stop live preview | 50_editor |
| `<leader>mf` | n | Pick file to preview | 50_editor |

## DAP (Debug)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>db` | n | Toggle breakpoint | 80_dap |
| `<leader>dB` | n | Conditional breakpoint | 80_dap |
| `<leader>dc` | n | Continue | 80_dap |
| `<leader>di` | n | Step into | 80_dap |
| `<leader>do` | n | Step over | 80_dap |
| `<leader>dO` | n | Step out | 80_dap |
| `<leader>dr` | n | Restart | 80_dap |
| `<leader>dt` | n | Terminate | 80_dap |
| `<leader>du` | n | Toggle DAP UI | 80_dap |
| `<leader>de` | n/v | Eval under cursor / selection | 80_dap |

## AI (Claude Code)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>ac` | n | Open Claude Code (terminal tab) | 90_ai |
| `<leader>af` | n | Add current file to Claude | 90_ai |

## Completion (blink.cmp)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<C-space>` | i | Show / toggle documentation | 70_completion |
| `<C-e>` | i | Hide completion | 70_completion |
| `<CR>` | i | Accept completion | 70_completion |
| `<Tab>` | i | Select next / snippet forward | 70_completion |
| `<S-Tab>` | i | Select prev / snippet backward | 70_completion |
| `<C-n>` | i | Select next | 70_completion |
| `<C-p>` | i | Select prev | 70_completion |
| `<C-d>` | i | Scroll documentation down | 70_completion |
| `<C-u>` | i | Scroll documentation up | 70_completion |

## Surround (mini.surround)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `sa` | n/v | Add surround | 30_mini |
| `sd` | n | Delete surround | 30_mini |
| `sr` | n | Replace surround | 30_mini |

## Python (only in .py files)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>pv` | n | Select venv | ftplugin/python |
| `<leader>pc` | n | Cached venv | ftplugin/python |
| `<leader>pr` | n | Run file | ftplugin/python |
| `<leader>dm` | n | Debug test method | ftplugin/python |
| `<leader>dk` | n | Debug test class | ftplugin/python |

## C/C++ (only in .c/.cpp files)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>ch` | n | Switch header/source (clangd) | ftplugin/cpp |
| `<leader>cb` | n | Build (cmake/make/meson) | ftplugin/cpp |

## Zig (only in .zig files)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>zb` | n | Zig build | ftplugin/zig |
| `<leader>zt` | n | Zig test | ftplugin/zig |
| `<leader>zr` | n | Zig run file | ftplugin/zig |

## HTTP / Kulala (only in .http files)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>kr` | n | Run request | ftplugin/http |
| `<leader>ka` | n | Run all requests | ftplugin/http |
| `<leader>kn` | n | Next request | ftplugin/http |
| `<leader>kp` | n | Prev request | ftplugin/http |
| `<leader>ke` | n | Select environment | ftplugin/http |
| `<leader>kc` | n | Copy as cURL | ftplugin/http |

## Lua (only in .lua files)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>lx` | n | Source current file | ftplugin/lua |

## Markdown (only in .md files)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `j` | n | Visual line down (wrap-aware) | ftplugin/markdown |
| `k` | n | Visual line up (wrap-aware) | ftplugin/markdown |

## Dashboard (mini.starter)

Type letters to filter items, `<CR>` to confirm. Source: `40_ui`.

| Key | Action |
|-----|--------|
| type letters | Filter items by name |
| `<CR>` | Open selected item |
| `<Tab>` / `<S-Tab>` | Next / prev item |
| `<C-c>` | Close starter |

## Clue Groups (mini.clue)

| Prefix | Group |
|--------|-------|
| `<leader>f` | +find |
| `<leader>g` | +git |
| `<leader>c` | +code |
| `<leader>d` | +debug |
| `<leader>n` | +test |
| `<leader>t` | +tab/terminal |
| `<leader>p` | +python |
| `<leader>z` | +zig |
| `<leader>h` | +harpoon |
| `<leader>y` | +yeet |
| `<leader>k` | +kulala |
| `<leader>a` | +ai |
| `<leader>l` | +lua |
| `<leader>m` | +preview |
| `<leader>w` | +window |

