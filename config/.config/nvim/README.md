# NeoVim

> Minimal. Native. No framework. No magic.

Built on `vim.pack` — Neovim's built-in package manager. Each numbered file in `plugin/` is auto-sourced at startup. Language configs live in `after/ftplugin/` and `after/lsp/` exactly where Neovim expects them.

No lazy-loading complexity. No plugin manager to debug. Just files.

---

## Structure

```
~/.config/nvim/
├── init.lua                   # loader cache, leader key, global hooks
│
├── plugin/                    # auto-sourced at startup, in order
│   ├── 10_options.lua         # vim.opt settings, diagnostics
│   ├── 20_keymaps.lua         # keymaps, autocmds
│   ├── 30_mini.lua            # mini.nvim — surround, pairs, icons, statusline
│   ├── 40_ui.lua              # catppuccin, tabby, rainbow-delimiters
│   ├── 50_editor.lua          # oil, fzf-lua, gitsigns, harpoon, conform, ufo
│   ├── 60_mason.lua           # mason — LSP auto-installer
│   ├── 70_completion.lua      # blink.cmp
│   ├── 80_dap.lua             # nvim-dap + dap-ui
│   └── 90_ai.lua              # codecompanion
│
├── after/
│   ├── ftplugin/              # per-language settings (tabstop, formatters, keymaps)
│   │   ├── c.lua / cpp.lua
│   │   ├── python.lua
│   │   ├── zig.lua
│   │   ├── lua.lua
│   │   ├── markdown.lua
│   │   └── http.lua
│   └── lsp/                   # LSP server configs (auto-loaded by vim.lsp)
│       ├── clangd.lua
│       ├── pyrefly.lua
│       ├── ruff.lua
│       ├── zls.lua
│       └── lua_ls.lua
```

---

## Adding a Language

**1.** Create `after/lsp/rust_analyzer.lua`:

```lua
-- after/lsp/rust_analyzer.lua
return {
  settings = {
    ['rust-analyzer'] = {
      checkOnSave = { command = 'clippy' },
    },
  },
}
```

**2.** Create `after/ftplugin/rust.lua`:

```lua
-- after/ftplugin/rust.lua
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4

vim.lsp.enable('rust_analyzer')

require('conform').formatters_by_ft.rust = { 'rustfmt' }
```

Drop both files in. Restart. Done.

---

## Tool Management

| Tool | Manager | Install |
|------|---------|---------|
| clangd, clang-format, lldb-dap | Homebrew | `brew install llvm` |
| zls | zvm | `zvm install zls` |
| pyrefly | uv | `uv tool install pyrefly` |
| ruff | uv | `uv tool install ruff` |
| debugpy | uv | `uv tool install debugpy` |
| lua_ls | Mason | auto-installed |
| stylua | Homebrew | `brew install stylua` |

---

## Key Bindings

### General

| Key | Mode | Action |
|-----|------|--------|
| `<C-s>` | n/i | Save |
| `<leader>q` | n | Quit |
| `<leader>/` | n | Live grep |
| `-` / `<leader>e` | n | File explorer (oil) |
| `<leader>cf` | n | Format |

### Navigation

| Key | Mode | Action |
|-----|------|--------|
| `<leader><space>` | n | Find files |
| `<leader>ff` | n | Find files |
| `<leader>fb` | n | Find buffers |
| `<leader>fr` | n | Recent files |

### Harpoon

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ha` | n | Add file |
| `<leader>hh` | n | Quick menu |
| `<leader>1–4` | n | Jump to mark 1–4 |

### LSP

| Key | Mode | Action |
|-----|------|--------|
| `gd` | n | Go to definition (new tab) |
| `gi` | n | Go to implementation (new tab) |
| `gr` | n | References |
| `K` | n | Hover docs |
| `<leader>cr` | n | Rename |
| `<leader>ca` | n | Code action |
| `[d` / `]d` | n | Prev/next diagnostic |

### DAP

| Key | Mode | Action |
|-----|------|--------|
| `<leader>db` | n | Toggle breakpoint |
| `<leader>dB` | n | Conditional breakpoint |
| `<leader>dc` | n | Continue |
| `<leader>di` | n | Step into |
| `<leader>do` | n | Step over |
| `<leader>dt` | n | Terminate |
| `<leader>du` | n | Toggle DAP UI |
| `<leader>de` | n | Eval under cursor |

### Language-specific

| Key | Lang | Action |
|-----|------|--------|
| `<leader>pv` | Python | Select venv |
| `<leader>pr` | Python | Run file |
| `<leader>dm` | Python | Debug test method |
| `<leader>dk` | Python | Debug test class |
| `<leader>ch` | C/C++ | Switch header/source |
| `<leader>cb` | C/C++ | Build (cmake/make/meson) |
| `<leader>zb` | Zig | Build |
| `<leader>zt` | Zig | Test |
| `<leader>zr` | Zig | Run |

---

## Installation

```bash
# Tools
brew install llvm stylua fzf ripgrep
uv tool install pyrefly ruff debugpy

# Config
mv ~/.config/nvim ~/.config/nvim.bak
git clone https://github.com/guzman109/dotfiles ~/.dotfiles
stow -d ~/.dotfiles config
nvim
```

## Updating Plugins

```vim
:lua vim.pack.update()
```

---

> Only add something when you feel the pain of not having it.
