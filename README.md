# dotfiles

Personal dotfiles for macOS development environment, managed with GNU Stow.

## Quick Start

```bash
# Install stow
brew install stow

# Clone to ~/.dotfiles
git clone https://github.com/guzman109/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Symlink everything
stow config
```

## What's Included

| Component | Description |
|-----------|-------------|
| **Fish Shell** | Shell configuration with Starship prompt, vi-style keybindings |
| **Neovim** | LazyVim-based setup with LSP for Swift, Python, Zig |
| **Kitty** | Terminal emulator with theme auto-switching |
| **Starship** | Custom prompt with git status, language versions, quotes |
| **Homebrew** | Package lists for reproducible installs |

## Structure

```
.dotfiles/
├── config/.config/
│   ├── fish/              # Fish shell
│   │   ├── config.fish    # Main config with PATH, aliases, keybindings
│   │   ├── completions/   # Tool completions (docker, swift, uv)
│   │   ├── functions/     # Custom functions (brew, cargo, mas)
│   │   └── conf.d/        # Auto-loaded configs
│   │
│   ├── nvim/              # Neovim (LazyVim)
│   │   ├── lua/config/    # Core settings
│   │   └── lua/plugins/   # Plugin configurations
│   │
│   ├── kitty/             # Kitty terminal
│   │   ├── kitty.conf     # Main config
│   │   └── current-theme.conf
│   │
│   ├── starship/          # Starship prompt
│   │   ├── starship.toml  # Prompt configuration
│   │   └── *.sh           # Helper scripts
│   │
│   ├── homebrew/          # Package management
│   │   ├── Brewfile       # Homebrew formulae
│   │   ├── BrewCaskfile   # GUI applications
│   │   ├── BrewTapfile    # Third-party taps
│   │   ├── Masfile        # Mac App Store apps
│   │   └── Cargofile      # Rust crates
│   │
│   └── inspiration/       # Daily quotes system
│       ├── quote-fetch.sh # Fetches quotes from API
│       └── quote-cache.sh # Displays cached quotes
│
├── docs/
│   └── SECRETS.md         # Secrets management guide
├── CLAUDE.md              # Claude Code reference
└── README.md
```

## Installation

### Prerequisites

```bash
brew install stow fish starship
```

### Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/guzman109/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Create symlinks:**
   ```bash
   stow config
   ```

3. **Install packages (optional):**
   ```bash
   # Homebrew packages
   brew bundle --file ~/.config/homebrew/Brewfile
   brew bundle --file ~/.config/homebrew/BrewCaskfile

   # Mac App Store apps (requires mas)
   brew install mas
   cat ~/.config/homebrew/Masfile | xargs -n1 mas install
   ```

4. **Set Fish as default shell:**
   ```bash
   echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
   chsh -s /opt/homebrew/bin/fish
   ```

5. **Set up secrets:** See [docs/SECRETS.md](docs/SECRETS.md)

### Removing Symlinks

```bash
stow -D config
```

## Configuration Details

### Fish Shell

**Aliases:**
- `ls` → `eza` (modern ls replacement)
- `cat` → `bat` (syntax-highlighted cat)
- `icat` → Kitty image viewer
- `ksh` → Kitty SSH with shell integration

**Vi-style keybindings:**
- `Alt+h/j/k/l` - Navigation
- `Alt+w/b/e` - Word movement
- `Alt+d/u/x` - Delete operations

**PATH includes:**
- `/opt/homebrew/bin` - Homebrew
- `~/.cargo/bin` - Rust
- `~/.local/share/bob/nvim-bin` - Bob-managed Neovim
- `~/.docker/bin` - Docker CLI

### Neovim

Based on [LazyVim](https://www.lazyvim.org/) with custom plugins:

**Language Support:**
| Language | LSP | Formatter | Linter |
|----------|-----|-----------|--------|
| Swift | sourcekit-lsp | swiftformat | - |
| Python | basedpyright | ruff | ruff |
| Zig | zls | zigfmt | - |

**Key Plugins:**
- `claudecode.nvim` - Claude Code integration (`<leader>a` prefix)
- `themery.nvim` - Theme switcher (`<leader>tt`)
- `nvim-ufo` - Modern folding with LSP
- `rainbow-delimiters` - Colored brackets

**Themes:** Catppuccin (default), Tokyo Night

### Starship Prompt

Custom prompt showing:
- Time (12-hour format)
- Directory with git status
- Language versions (when in project)
- Custom success/error symbols
- Daily inspirational quote (via quote-cache.sh)

### Homebrew Package Management

Packages are organized into separate files:

| File | Contents |
|------|----------|
| `Brewfile` | CLI tools (git, fzf, jq, etc.) |
| `BrewCaskfile` | GUI apps |
| `BrewTapfile` | Third-party taps |
| `Masfile` | Mac App Store app IDs |
| `Cargofile` | Rust crates |

**Update all packages:**
```bash
brew_update  # alias defined in fish config
```

### Inspiration (Quotes)

Daily motivational quotes displayed in your prompt and Neovim dashboard.

**Setup:**
1. Get an API key from [api-ninjas.com](https://api-ninjas.com)
2. Add to your secrets: `set -gx API_NINJAS_KEY "your-key"`
3. Run `~/.config/inspiration/quote-fetch.sh` (or let cron do it)

Quotes are cached in SQLite at `~/.cache/inspiration/quotes.db`.

## Secrets

API keys and tokens should never be committed. See [docs/SECRETS.md](docs/SECRETS.md) for:
- Plain text secrets file
- `pass` (GPG-encrypted)
- macOS Keychain
- 1Password CLI

## Customization

### Adding a new tool's config

1. Create the config in `config/.config/toolname/`
2. Run `stow -R config` to update symlinks

### Overriding without modifying

Fish sources all files in `~/.config/fish/conf.d/`. Create local overrides there:
```fish
# ~/.config/fish/conf.d/local.fish
set -gx MY_CUSTOM_VAR "value"
```

## Troubleshooting

### Stow conflicts

If stow reports conflicts, existing files may be in the way:
```bash
# See what would happen
stow -n -v config

# Backup and remove conflicting files, then retry
stow config
```

### Fish not finding commands

Ensure Homebrew is in PATH. The config handles this for macOS, but you may need to run:
```bash
/opt/homebrew/bin/brew shellenv >> ~/.config/fish/config.fish
```

### Neovim plugins not loading

```bash
# Inside Neovim
:Lazy sync
```

## License

MIT
