# ClaudlosVim Keymaps

> Leader: `<Space>` | LocalLeader: `<Space>`

## General

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<C-s>` | n | Save | 00-core |
| `<Esc>` | n | Clear search highlight | 00-core |
| `j` / `k` | n | Smart visual line movement (no count) | 00-core |
| `<A-j>` | n | Move line down | 00-core |
| `<A-k>` | n | Move line up | 00-core |
| `<A-j>` | v | Move selection down | 00-core |
| `<A-k>` | v | Move selection up | 00-core |
| `<` | v | Indent left and keep selection | 00-core |
| `>` | v | Indent right and keep selection | 00-core |
| `<Esc><Esc>` | t | Exit terminal mode | 00-core |
| `q` | n | Close (help, man, qf, checkhealth, dap-float) | 00-core |

## Navigation

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<C-h>` | n | Go to left split | 00-core |
| `<C-j>` | n | Go to lower split | 00-core |
| `<C-k>` | n | Go to upper split | 00-core |
| `<C-l>` | n | Go to right split | 00-core |
| `<S-h>` | n | Previous tab | 00-core |
| `<S-l>` | n | Next tab | 00-core |

## Tabs

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>tn` | n | New tab | 00-core |
| `<leader>tc` | n | Close tab | 00-core |
| `<leader>to` | n | Close other tabs | 00-core |
| `<leader>tr` | n | Close tabs to right | 00-core |

## Windows / Splits

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>wv` | n | Split vertical | 00-core |
| `<leader>ws` | n | Split horizontal | 00-core |
| `<leader>wd` | n | Close split | 00-core |
| `<leader>wo` | n | Close other splits | 00-core |
| `<leader>w=` | n | Equalize splits | 00-core |
| `<leader>wT` | n | Split to tab | 00-core |

## LSP (only when server attached)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `gd` | n | Go to definition (new tab) | 00-core |
| `gD` | n | Go to declaration | 00-core |
| `gr` | n | References | 00-core |
| `gi` | n | Implementation (new tab) | 00-core |
| `K` | n | Hover docs | 00-core |
| `<leader>cr` | n | Rename symbol | 00-core |
| `<leader>ca` | n | Code action | 00-core |
| `<leader>cs` | n | Signature help | 00-core |
| `<leader>ci` | n | Toggle inlay hints | 00-core |
| `<C-s>` | i | Signature help | 00-core |

## Code

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>cf` | n | Format (conform) | 00-core |
| `<leader>cd` | n | Line diagnostics | 00-core |
| `]d` | n | Next diagnostic | 00-core |
| `[d` | n | Prev diagnostic | 00-core |
| `<leader>co` | n | Code outline (aerial) | editor-code |
| `{` | n | Prev symbol (aerial) | editor-code |
| `}` | n | Next symbol (aerial) | editor-code |

## Finder (fzf-lua)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader><space>` | n | Find files | editor-finder |
| `ff` | n | Find files | editor-finder |
| `<leader>/` | n | Live grep | editor-finder |
| `<leader>fb` | n | Buffers | editor-finder |
| `<leader>fh` | n | Help tags | editor-finder |
| `<leader>fr` | n | Recent files | editor-finder |
| `<leader>fd` | n | Diagnostics | editor-finder |
| `<leader>fs` | n | Document symbols | editor-finder |

## Oil (File Explorer)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `-` | n | Open parent directory | editor-tools |
| `<leader>e` | n | File explorer | editor-tools |
| `<leader>E` | n | File explorer (new tab) | editor-tools |
| `<CR>` | n | Select (in oil) | editor-tools |
| `<C-v>` | n | Open in vsplit (in oil) | editor-tools |
| `<C-s>` | n | Open in split (in oil) | editor-tools |
| `<C-t>` | n | Open in new tab (in oil) | editor-tools |
| `-` | n | Go to parent (in oil) | editor-tools |
| `_` | n | Open cwd (in oil) | editor-tools |
| `g.` | n | Toggle hidden files (in oil) | editor-tools |
| `g?` | n | Show help (in oil) | editor-tools |
| `q` | n | Close oil | editor-tools |

## Harpoon

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>ha` | n | Add file to harpoon | editor-tools |
| `<leader>hd` | n | Remove current file | editor-tools |
| `<leader>hh` | n | Harpoon menu (fzf) | editor-tools |
| `<leader>1` | n | Jump to harpoon file 1 | editor-tools |
| `<leader>2` | n | Jump to harpoon file 2 | editor-tools |
| `<leader>3` | n | Jump to harpoon file 3 | editor-tools |
| `<leader>4` | n | Jump to harpoon file 4 | editor-tools |
| `<C-S-P>` | n | Harpoon prev | editor-tools |
| `<C-S-N>` | n | Harpoon next | editor-tools |
| `<C-v>` | n | Open in vsplit (in harpoon menu) | editor-tools |
| `<C-x>` | n | Open in split (in harpoon menu) | editor-tools |
| `<C-t>` | n | Open in new tab (in harpoon menu) | editor-tools |

## Folding (ufo)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `zR` | n | Open all folds | editor-tools |
| `zM` | n | Close all folds | editor-tools |
| `zK` | n | Peek fold | editor-tools |

## Git (gitsigns)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `]h` | n | Next hunk | editor-git |
| `[h` | n | Prev hunk | editor-git |
| `<leader>gs` | n | Stage hunk | editor-git |
| `<leader>gr` | n | Reset hunk | editor-git |
| `<leader>gS` | n | Stage buffer | editor-git |
| `<leader>gu` | n | Undo stage hunk | editor-git |
| `<leader>gp` | n | Preview hunk | editor-git |
| `<leader>gb` | n | Blame line | editor-git |
| `<leader>gd` | n | Diff this | editor-git |

## DAP (Debug)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>db` | n | Toggle breakpoint | editor-tools |
| `<leader>dB` | n | Conditional breakpoint | editor-tools |
| `<leader>dc` | n | Continue | editor-tools |
| `<leader>di` | n | Step into | editor-tools |
| `<leader>do` | n | Step over | editor-tools |
| `<leader>dO` | n | Step out | editor-tools |
| `<leader>dr` | n | Restart | editor-tools |
| `<leader>dt` | n | Terminate | editor-tools |
| `<leader>du` | n | Toggle DAP UI | editor-tools |
| `<leader>de` | n/v | Eval under cursor / selection | editor-tools |

## AI (CodeCompanion)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<C-a>` | n | CodeCompanion Actions | editor-tools |
| `<LocalLeader>a` | n/v | Toggle Chat | editor-tools |
| `ga` | v | Add Selection to Chat | editor-tools |
| `<leader>ac` | n/v | Toggle Chat | editor-tools |
| `<leader>af` | n | Focus Chat | editor-tools |
| `<leader>ab` | n | Add Buffer to Chat | editor-tools |
| `<leader>as` | v | Add Selection to Chat | editor-tools |
| `<leader>aa` | n | Accept Diff | editor-tools |
| `<leader>ad` | n | Reject Diff | editor-tools |
| `:cc` | cmd | :CodeCompanion abbreviation | editor-tools |

## Completion (blink.cmp)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<C-space>` | i | Show / toggle documentation | editor-completion |
| `<C-e>` | i | Hide completion | editor-completion |
| `<CR>` | i | Accept completion | editor-completion |
| `<Tab>` | i | Select next / snippet forward | editor-completion |
| `<S-Tab>` | i | Select prev / snippet backward | editor-completion |
| `<C-n>` | i | Select next | editor-completion |
| `<C-p>` | i | Select prev | editor-completion |
| `<C-d>` | i | Scroll documentation down | editor-completion |
| `<C-u>` | i | Scroll documentation up | editor-completion |

## Surround (mini.surround)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `sa` | n/v | Add surround | 01-mini |
| `sd` | n | Delete surround | 01-mini |
| `sr` | n | Replace surround | 01-mini |

## Theme

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>Td` | n | Day theme (latte) | 02-ui |
| `<leader>Tn` | n | Night theme (mocha) | 02-ui |

## Python (only in .py files)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>pv` | n | Select venv | lang-python |
| `<leader>pc` | n | Cached venv | lang-python |
| `<leader>pr` | n | Run file | lang-python |
| `<leader>dm` | n | Debug test method | lang-python |
| `<leader>dk` | n | Debug test class | lang-python |

## C/C++ (only in .c/.cpp files)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>ch` | n | Switch header/source | lang-cpp |
| `<leader>cb` | n | Build (cmake/make/meson) | lang-cpp |

## Zig (only in .zig files)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>zb` | n | Zig build | lang-zig |
| `<leader>zt` | n | Zig test | lang-zig |
| `<leader>zr` | n | Zig run file | lang-zig |

## HTTP / Kulala (only in .http files)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>kr` | n | Run request | lang-http |
| `<leader>ka` | n | Run all requests | lang-http |
| `<leader>kn` | n | Next request | lang-http |
| `<leader>kp` | n | Prev request | lang-http |
| `<leader>ke` | n | Select environment | lang-http |
| `<leader>kc` | n | Copy as cURL | lang-http |

## Lua (only in .lua files)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `<leader>lx` | n | Source current file | lang-lua |

## Markdown (only in .md files)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `j` | n | Visual line down (wrap-aware) | lang-markdown |
| `k` | n | Visual line up (wrap-aware) | lang-markdown |

## Dashboard (alpha)

| Key | Mode | Action | File |
|-----|------|--------|------|
| `f` | n | Find files | 02-ui |
| `g` | n | Live grep | 02-ui |
| `r` | n | Recent files | 02-ui |
| `t` | n | TODOs | 02-ui |
| `c` | n | Edit config | 02-ui |
| `k` | n | Keymaps | 02-ui |
| `u` | n | Update plugins | 02-ui |
| `x` | n | Clean unused plugins | 02-ui |
| `q` | n | Quit | 02-ui |

## Clue Groups (mini.clue)

| Prefix | Group |
|--------|-------|
| `<leader>f` | +find |
| `<leader>g` | +git |
| `<leader>c` | +code |
| `<leader>d` | +debug |
| `<leader>t` | +tab |
| `<leader>p` | +python |
| `<leader>z` | +zig |
| `<leader>h` | +harpoon |
| `<leader>k` | +kulala |
| `<leader>a` | +ai |
| `<leader>l` | +lua |
| `<leader>w` | +window |

## Plugin Management

| Command | Action |
|---------|--------|
| `:lua vim.pack.update()` | Update all plugins |
| `:lua vim.pack.update({ 'name' })` | Update specific plugin |
| `:lua vim.pack.del({ 'name' }, { force = true })` | Remove plugin |
