#!/bin/bash

# Path to Starship config
CONFIG_FILE="$HOME/.config/starship/starship.toml"

# Function to get current appearance
get_appearance() {
    defaults read -g AppleInterfaceStyle 2>/dev/null
}

# Function to update Starship theme
update_theme() {
    local appearance=$(get_appearance)

    if [ "$appearance" = "Dark" ]; then
        sed -i '' "s/palette = 'catppuccin_.*'/palette = 'catppuccin_mocha'/" "$CONFIG_FILE"
    else
        sed -i '' "s/palette = 'catppuccin_.*'/palette = 'catppuccin_latte'/" "$CONFIG_FILE"
    fi
}

# Initial update
update_theme
LAST_APPEARANCE=$(get_appearance)

# Monitor for changes
while true; do
    sleep 2
    CURRENT_APPEARANCE=$(get_appearance)

    if [ "$CURRENT_APPEARANCE" != "$LAST_APPEARANCE" ]; then
        update_theme
        LAST_APPEARANCE="$CURRENT_APPEARANCE"
    fi
done
