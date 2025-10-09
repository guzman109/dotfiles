# Homebrew
if test (uname -s) = Darwin
  /opt/homebrew/bin/brew shellenv | source
  alias spm="swift package"
  spm completion-tool generate-fish-script | source
end

# PATHs
set -U fish_user_paths "$HOME/.cargo/bin" "$HOME/.bun/bin" "$HOME/.local/share/bob/nvim-bin"
# Starship
set -Ux STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"
starship init fish | source

# Aliases
alias ls="eza"
alias cat="bat"

