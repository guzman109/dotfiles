# Nix
if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
  source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
end

# nix-darwin
if test -e /etc/static/fish/rc.d/nix-darwin.fish
  source /etc/static/fish/rc.d/nix-darwin.fish
end

# Homebrew
if test (uname -s) = Darwin
  /opt/homebrew/bin/brew shellenv | source
  alias spm="swift package"
  spm completion-tool generate-fish-script | source
end

# Kitty completions
kitty +complete setup fish | source

# PATHs
set -U fish_user_paths "$HOME/.cargo/bin" "$HOME/.bun/bin"  "/run/current-system/sw/bin" "/nix/var/nix/profiles/default/bin"

# Starship
set -Ux STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"
starship init fish | source


# Aliases
alias ls="eza"
alias cat="bat"
alias icat="kitty +kitten icat"
alias ksh="kitty +kitten ssh"

# Vi-style keybindings
# History navigation
bind \ej down-or-search  # Alt+j for next command
bind \ek up-or-search    # Alt+k for previous command

# Line navigation
bind \eh backward-char        # Alt+h - move left
bind \el forward-char         # Alt+l - move right
bind \e^ beginning-of-line    # Alt+^ - go to start of line
bind \e\$ end-of-line         # Alt+$ - go to end of line

# Word navigation
bind \eb backward-word        # Alt+b - move back one word
bind \ew forward-word         # Alt+w - move forward one word
bind \ee forward-word         # Alt+e - move to end of word (same as w in fish)

# Delete operations
bind \ex kill-line            # Alt+x - delete to end of line
bind \eu backward-kill-line   # Alt+u - delete to beginning of line
bind \ed kill-word            # Alt+d - delete word forward
