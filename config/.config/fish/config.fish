# ~/.config/fish/config.fish

# ─── Platform Detection ───
set -l is_mac (test (uname -s) = Darwin && echo yes || echo no)

# ─── Homebrew (macOS only) ───
if test $is_mac = yes
    /opt/homebrew/bin/brew shellenv | source
    alias spm="swift package"
    spm completion-tool generate-fish-script | source
end

# ─── PATHs ───
set -gx PATH $PATH
fish_add_path --path \
    $HOME/.cargo/bin \
    $HOME/.local/share/bob/nvim-bin \
    $HOME/.local/bin

if test $is_mac = yes
    fish_add_path --path \
        /opt/homebrew/bin \
        /opt/homebrew/opt/libpq/bin \
        $HOME/.docker/bin \
        $HOME/.bun/bin
end

# ─── Tools ───
# vcpkg (same path on macOS and Linux)
if test -d $HOME/.vcpkg
    set -gx VCPKG_ROOT $HOME/.vcpkg
    fish_add_path $VCPKG_ROOT
    alias vcpkg_update="git -C ~/.vcpkg pull && ~/.vcpkg/bootstrap-vcpkg.sh"
end

# Direnv
if command -q direnv
    direnv hook fish | source
end

# Starship
if command -q starship
    set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml
    starship init fish | source
end

# Kitty
if test "$TERM" = xterm-kitty
    kitty +complete setup fish | source
    alias icat="kitty +kitten icat"
    alias s="kitten ssh"
end

# ─── Aliases ───
command -q eza && alias ls="eza"
command -q bat && alias cat="bat"

if test $is_mac = yes
    alias brew_update="brew bundle --file ~/.config/homebrew/Brewfile"
end

# # ─── Keybindings (Alt + vim-style) ───
# # History
# bind \ej down-or-search
# bind \ek up-or-search
#
# # Line navigation
# bind \eh backward-char
# bind \el forward-char
# bind \e^ beginning-of-line
# bind \e\$ end-of-line
#
# # Word navigation
# bind \eb backward-word
# bind \ew forward-word
# bind \ee forward-word
#
# # Delete operations
# bind \ex kill-line
# bind \eu backward-kill-line
# bind \ed kill-word

# ZVM
set -gx ZVM_INSTALL "$HOME/.zvm/self"
set -gx PATH $PATH "$HOME/.zvm/bin"
set -gx PATH $PATH "$ZVM_INSTALL/"
