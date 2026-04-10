# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a macOS dotfiles repository managing configuration for development tools and terminal environments. The primary structure uses a `config/.config/` directory containing all application configurations.

## Repository Structure

- `config/.config/` - Main configuration directory containing:
  - `fish/` - Fish shell configuration and completions
  - `nvim/` - ClaudlosVim (custom minimal Neovim config)
  - `ghostty/` - Ghostty terminal emulator config
  - `kitty/` - Kitty terminal emulator config
  - `starship/` - Starship prompt configuration
  - `homebrew/` - Brewfile for Homebrew packages
  - `inspiration/` - Quote cache scripts for dashboard

## Key Configuration Files

### Fish Shell (`config/.config/fish/`)
- `config.fish` - Main shell configuration with:
  - Homebrew environment setup (macOS)
  - PATH configuration for Cargo, Bun, and Bob (nvim version manager)
  - Starship prompt initialization
  - Shell aliases (eza for ls, bat for cat)
- `completions/` - Auto-completion scripts for various tools (uv, bun, swift, colima)
- `conf.d/` - Additional configuration snippets loaded on shell startup

### Neovim (`config/.config/nvim/`)

**ClaudlosVim v0.3.0** — a custom minimal setup using Neovim's native `vim.pack.add()` package manager (no lazy.nvim or Mason). Plugins load from numbered files in `plugin/` (alphabetical order):

| File | Purpose |
|------|---------|
| `plugin/10_options.lua` | Options, diagnostics, providers |
| `plugin/20_keymaps.lua` | Keymaps, LSP on-attach, autocommands |
| `plugin/30_mini.lua` | mini.nvim modules |
| `plugin/40_ui.lua` | Catppuccin, auto-dark-mode, lualine, tabby, indent-blankline, mini.starter dashboard |
| `plugin/50_editor.lua` | fzf-lua, gitsigns, aerial, ufo, harpoon2, conform, treesitter, markview, live-preview, neotest, kulala, venv-selector, nvim-highlight-colors |
| `plugin/60_lsp.lua` | Enables LSPs via `vim.lsp.enable()` |
| `plugin/70_completion.lua` | Completion setup |
| `plugin/80_dap.lua` | Debug adapter protocol |
| `plugin/90_ai.lua` | CodeCompanion with claude_code adapter |

**LSP configs** live in `after/lsp/<server>.lua` (one file per server). Active servers:
`biome`, `clangd`, `cssls`, `emmylua`, `fish_lsp`, `just`, `pyrefly`, `ruff`, `superhtml`, `tailwindcss`, `vtsls`, `zls`

**Filetype settings** live in `after/ftplugin/<filetype>.lua`.

**Key behaviors:**
- Plugin manager: `vim.pack.add()` (native Neovim, no lazy.nvim)
- Format on save: conform.nvim, 500ms timeout, lsp fallback
- Folding: nvim-ufo with LSP + indent providers
- AI: CodeCompanion (`<C-a>` actions, `<leader>ac` toggle chat) using claude_code adapter
- Finder: fzf-lua (`<leader><space>` files, `<leader>/` grep)
- File marks: Harpoon2 (`<leader>ha` add, `<leader>1-4` jump)
- Code outline: Aerial (`<leader>co`)
- Testing: Neotest (Python/pytest, C++/gtest, Zig)
- HTTP client: Kulala

**Formatters by filetype:**
- JS/TS/CSS/JSON: biome
- HTML: superhtml
- Python: ruff_format + ruff_fix + ruff_organize_imports
- C/C++: clang-format (`/opt/homebrew/opt/llvm/bin/clang-format`)
- Lua: stylua
- Zig: zigfmt
- Fish: fish_indent
- Just: just --fmt

### Terminal Emulators

**Ghostty** (`config/.config/ghostty/config.ghostty`):
- MonoLisa Variable font at 14pt, font-thicken enabled
- Catppuccin Latte (light) / Catppuccin Macchiato (dark) — auto-switching
- Background opacity 0.9
- Fish shell integration
- Vim-style split navigation (ctrl+alt+hjkl or shift+alt+hjkl)
- shift+enter sends ESC+Enter (Claude Code multi-line support)

**Kitty** (`config/.config/kitty/`):
- `kitty.conf` - Main configuration
- `dark-theme.auto.conf` / `light-theme.auto.conf` - Theme files

### Starship Prompt (`config/.config/starship/starship.toml`)
- Custom format with time, username, directory, git status
- Language version indicators for many programming languages
- Custom success/error symbols
- 3-second command timeout
- 12-hour time format

## Development Workflow

This is a dotfiles repository — there are no build, test, or lint commands at the repository level. Changes are typically:

1. Edit configuration files directly
2. Test by reloading the affected application (e.g., `source ~/.config/fish/config.fish`, reopen nvim)
3. Commit changes with git

## Session Notes

At the end of each session, write a markdown note to `~/.dotfiles/notes/YYYY-MM-DD.md` (use today's date). If a file for today already exists, append to it. Each note should include:

- **What we worked on** — files changed, features added, bugs fixed
- **Decisions made** — why we chose a particular approach
- **Context** — anything useful for future sessions

After writing, run `/Users/guzman.109/.bun/bin/qmd update --collection dotfiles` to re-index.

To search past sessions: `qmd query "..." -c dotfiles`

## Important Notes

- **Native plugin manager**: Use `vim.pack.add()` patterns when adding plugins — no lazy.nvim specs
- **No Mason**: LSPs and tools are installed via Homebrew or manually; no Mason
- **LSP files**: Add new LSP configs in `after/lsp/<server>.lua`, then enable in `plugin/60_lsp.lua`
- **Filetype settings**: Per-language indent/settings go in `after/ftplugin/<filetype>.lua`
- **Paths**: Several configurations use absolute paths (e.g., formatter paths). When modifying, maintain these absolute references
- **macOS-specific**: Fish config checks for Darwin (macOS) before setting up Homebrew
- **Shell Integration**: Ghostty is configured for Fish shell integration
