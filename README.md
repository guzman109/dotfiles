# dotfiles

Personal dotfiles for macOS development environment.

## What's Included

- **Fish Shell** - Shell configuration with Starship prompt
- **Neovim** - LazyVim-based configuration with LSP support for Swift, Python, and Zig
- **Terminal Emulators** - Ghostty and Kitty configurations
- **Themes** - Catppuccin and Tokyo Night with auto-switching support

## Installation

This repository uses [GNU Stow](https://www.gnu.org/software/stow/) to manage symlinks.

### Prerequisites

Install Stow:
```bash
# macOS
brew install stow
```

### Setup

1. Clone this repository to your home directory as `.dotfiles`:
```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

**Note:** The repository name on GitHub is `dotfiles`, but we clone it to `~/.dotfiles` (with a dot) to keep it hidden in your home directory.

2. Use Stow to symlink configurations:
```bash
# Symlink all configs
stow config

# Or symlink specific configs
stow -t ~ config
```

This will create symlinks from `~/.config/` to the configuration files in this repository.

### Removing Symlinks

To remove symlinks:
```bash
stow -D config
```

## Structure

```
.dotfiles/
├── config/
│   └── .config/
│       ├── fish/          # Fish shell configuration
│       ├── nvim/          # Neovim (LazyVim) configuration
│       ├── ghostty/       # Ghostty terminal config
│       ├── kitty/         # Kitty terminal config
│       └── starship/      # Starship prompt config
├── CLAUDE.md              # Claude Code reference
└── README.md
```

## Key Features

### Fish Shell
- Homebrew integration
- Custom aliases (eza, bat)
- Starship prompt with git integration
- Completions for Swift, Rust, Python tools

### Neovim
- LazyVim distribution
- LSP support for Swift (sourcekit), Python (basedpyright/ruff), Zig (zls)
- Auto-formatting with conform.nvim (swiftformat, ruff, zigfmt)
- Claude Code integration
- Catppuccin and Tokyo Night themes

### Terminal
- Ghostty: 0.8 opacity with blur, Catppuccin themes
- Kitty: Alternative terminal configuration
- Both configured for Fish shell integration
