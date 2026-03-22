# ClaudlosVim

Minimal. Native. Organized by language.

Built on `vim.pack` following [echasnovski's guide](https://www.echasnovski.github.io/posts/a-guide-to-vim-pack/). Each file groups `vim.pack.add()` with its config — install and setup together, exactly as recommended.

## Philosophy

- **`plugin/` directory** — Neovim auto-discovers files, no manual requires
- **Language-first** — everything for a language lives in one file
- **Native APIs** — `vim.pack`, `vim.lsp`, `vim.treesitter`
- **External tools** — each ecosystem manages its own (uv, brew, zvm)

## Structure

```
~/.config/nvim/
├── init.lua                  # vim.loader, leader, hooks (tiny)
├── plugin/
│   ├── 00-core.lua           # options, keymaps, autocmds, diagnostics
│   ├── 01-mini.lua           # mini.nvim (surround, pairs, icons, statusline)
│   ├── 02-ui.lua             # catppuccin, rainbow-delimiters
│   ├── editor-completion.lua # blink.cmp
│   ├── editor-finder.lua     # fzf-lua
│   ├── editor-git.lua        # gitsigns
│   ├── editor-tools.lua      # oil, ufo, harpoon, conform, dap, codecompanion
│   ├── lang-cpp.lua          # clangd + clang-format + lldb + keymaps
│   ├── lang-python.lua       # pyrefly + ruff + debugpy + venv + keymaps
│   ├── lang-zig.lua          # zls + zigfmt + lldb + keymaps
│   ├── lang-lua.lua          # lua_ls + stylua + mason + keymaps
│   └── lang-http.lua         # kulala
```

## Adding a New Language

Create `plugin/lang-rust.lua`:

```lua
vim.lsp.config('rust_analyzer', {})
vim.lsp.enable({ 'rust_analyzer' })
require('conform').formatters_by_ft.rust = { 'rustfmt' }
require('nvim-treesitter').setup({ ensure_installed = { 'rust' } })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'rust',
  callback = function()
    vim.opt_local.tabstop = 4
  end,
})
```

Drop the file in, restart. Done.

## Tool Management

| Tool | Manager | Install |
|------|---------|---------|
| clangd, clang-format, lldb-dap | Homebrew LLVM | `brew install llvm` |
| zls | zvm | `zvm install zls` |
| pyrefly | uv | `uv tool install pyrefly` |
| ruff | uv | `uv tool install ruff` |
| debugpy | uv/pip | `uv tool install debugpy` |
| lua_ls | Mason | (auto-installed) |
| stylua | Homebrew | `brew install stylua` |

## Key Bindings

### Global
| Key | Action |
|-----|--------|
| `<leader>w` | Save |
| `<leader>q` | Quit |
| `<leader><space>` / `ff` | Find files |
| `<leader>/` | Live grep |
| `-` / `<leader>e` | File explorer (oil) |
| `<leader>cf` | Format |

### Harpoon
| Key | Action |
|-----|--------|
| `<leader>ha` | Add file |
| `<leader>hh` | Quick menu |
| `<leader>1-4` | Jump to file 1-4 |

### LSP (on attach)
| Key | Action |
|-----|--------|
| `gd` | Definition |
| `gr` | References |
| `K` | Hover |
| `<leader>cr` | Rename |
| `<leader>ca` | Code action |

### DAP
| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dc` | Continue |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>dt` | Terminate |
| `<leader>du` | Toggle DAP UI |
| `<leader>de` | Eval under cursor |

### Python
| Key | Action |
|-----|--------|
| `<leader>pv` | Select venv |
| `<leader>pr` | Run file |
| `<leader>dm` | Debug test method |
| `<leader>dk` | Debug test class |

### C/C++
| Key | Action |
|-----|--------|
| `<leader>ch` | Switch header/source |
| `<leader>cb` | Build (cmake/make/meson) |

### Zig
| Key | Action |
|-----|--------|
| `<leader>zb` | Build |
| `<leader>zt` | Test |
| `<leader>zr` | Run file |

## Installation

```bash
# Prereqs
brew install llvm stylua fzf ripgrep
uv tool install pyrefly ruff debugpy

# Install ClaudlosVim
mv ~/.config/nvim ~/.config/nvim.bak
git clone https://github.com/yourusername/claudlosvim ~/.config/nvim
nvim
```

## Updating Plugins

```vim
:lua vim.pack.update()
```

## The Rule

> Only add something when you feel the pain of not having it.
