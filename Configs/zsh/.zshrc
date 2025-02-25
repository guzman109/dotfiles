# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

autoload -U compinit
compinit

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

## history
#setopt APPEND_HISTORY
## for sharing history between zsh processes
#setopt INC_APPEND_HISTORY
#setopt SHARE_HISTORY

## never ever beep ever
#setopt NO_BEEP

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
#MAILCHECK=0

# autoload -U colors
#colors

# Ultramarine ZSH config
# initialize starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh-autosuggestions/zsh-autosuggestions.zsh

# Ctrl + Arrow keybindings
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# Ctrl + Backspace/Delete Kebindings
bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word

# ALt + Backspace/Delete Keybinds
bindkey "^[[3~" delete-char
bindkey -M emacs '^[[3;3~' kill-word

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt SHARE_HISTORY

. "$HOME/.cargo/env"
. "$HOME/.local/bin/env"
##################################################################################################################
# Local PATH
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.local/share/bob/nvim-bin:$PATH"

# Alias
alias ls="eza"
alias ksh="kitty +kitten ssh"
alias cat="bat"
alias icat="kitty icat"
alias switch-theme="kitty +kitten themes"
alias klite="kitten themes --reload-in=all 'Catppuccin-Latte'"
alias knite="kitten themes --reload-in=all 'Catppuccin-Macchiato'"
alias cargo-update="cargo-install-update install-update --all"
alias mc="mcli"
alias dotfiles="cd /Users/carlosguzman/Library/'Application Support'/dotfiles"
eval "$(fnm env --use-on-cd)"

eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"
