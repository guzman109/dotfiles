# Homebrew
if test (uname -s) = Darwin
  /opt/homebrew/bin/brew shellenv | source
end

# PATHs
set -U fish_user_paths "$HOME/.bun/bin"

# Starship
set -Ux STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"
starship init fish | source

# Kitty
alias ksh="kitten ssh"

# Aliases
alias ls="eza"
alias ksh="kitty +kitten ssh"
alias cat="bat"
alias icat="kitty icat"
alias switch-theme="kitty +kitten themes"
alias klite="kitten themes --reload-in=all 'Catppuccin-Latte'"
alias knite="kitten themes --reload-in=all 'Catppuccin-Macchiato'"
alias spm="swift package"

spm completion-tool generate-fish-script | source
