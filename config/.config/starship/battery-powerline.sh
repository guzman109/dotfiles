#!/bin/bash

# Get battery percentage
if [[ "$OSTYPE" == "darwin"* ]]; then
    battery_pct=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
    charging=$(pmset -g batt | grep -q 'AC Power' && echo "yes" || echo "no")
else
    exit 0
fi

# Determine color based on battery level
if [ "$battery_pct" -le 10 ]; then
    color="red"
    symbol="󰢟"
elif [ "$battery_pct" -le 20 ]; then
    color="maroon"
    symbol="󰂃"
elif [ "$battery_pct" -le 30 ]; then
    color="peach"
    symbol="󰂃"
elif [ "$battery_pct" -le 50 ]; then
    color="yellow"
    symbol="󰂃"
else
    color="lavender"
    symbol="󰁹"
fi

# Use charging symbol if charging
if [ "$charging" == "yes" ]; then
    symbol="󰂄"
fi

echo "$symbol $battery_pct% $color"
