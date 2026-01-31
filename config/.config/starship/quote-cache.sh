#!/bin/bash

# ============ CONFIGURATION ============
MAX_WIDTH=120
BOX_ICON=""
# =======================================

# Parse arguments
WRAP_WIDTH=0
BOX_MODE=0
BOX_WIDTH=60
while [[ $# -gt 0 ]]; do
    case $1 in
        --wrap)
            WRAP_WIDTH="${2:-50}"
            shift 2
            ;;
        --box)
            BOX_MODE=1
            BOX_WIDTH="${2:-60}"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

DB_FILE="$HOME/.cache/starship/quotes.db"
TODAY=$(date +%Y-%m-%d)

if [ -f "$DB_FILE" ]; then
    # Get today's quote, or fall back to the most recent one
    RESULT=$(sqlite3 -separator '|' "$DB_FILE" \
      "SELECT quote, author FROM quotes WHERE fetched_date = '$TODAY' LIMIT 1;" 2>/dev/null)

    if [ -z "$RESULT" ]; then
        RESULT=$(sqlite3 -separator '|' "$DB_FILE" \
          "SELECT quote, author FROM quotes ORDER BY fetched_date DESC LIMIT 1;" 2>/dev/null)
    fi

    if [ -n "$RESULT" ]; then
        QUOTE=$(echo "$RESULT" | cut -d'|' -f1)
        AUTHOR=$(echo "$RESULT" | cut -d'|' -f2)

        if [ -n "$AUTHOR" ] && [ "$AUTHOR" != "null" ]; then
            if [ "$BOX_MODE" -eq 1 ]; then
                OUTPUT="$BOX_ICON \"$QUOTE\" — $AUTHOR $BOX_ICON"
            else
                OUTPUT="\"$QUOTE\" — $AUTHOR"
            fi
        else
            if [ "$BOX_MODE" -eq 1 ]; then
                OUTPUT="$BOX_ICON \"$QUOTE\" $BOX_ICON"
            else
                OUTPUT="\"$QUOTE\""
            fi
        fi

        if [ "$BOX_MODE" -eq 1 ]; then
            # Box mode for neovim
            INNER_WIDTH=$((BOX_WIDTH - 4))

            # Top border
            printf "╭"
            printf '─%.0s' $(seq 1 $((BOX_WIDTH - 2)))
            printf "╮\n"

            # Wrap and print each line
            echo "$OUTPUT" | fold -s -w "$INNER_WIDTH" | while IFS= read -r line; do
                PADDING=$((INNER_WIDTH - ${#line}))
                printf "│ %s%*s │\n" "$line" "$PADDING" ""
            done

            # Bottom border
            printf "╰"
            printf '─%.0s' $(seq 1 $((BOX_WIDTH - 2)))
            printf "╯\n"
        elif [ "$WRAP_WIDTH" -gt 0 ]; then
            # Wrap mode
            echo "$OUTPUT" | fold -s -w "$WRAP_WIDTH"
        else
            # Truncate mode for starship
            if [ ${#OUTPUT} -gt $MAX_WIDTH ]; then
                echo "${OUTPUT:0:$((MAX_WIDTH - 3))}..."
            else
                echo "$OUTPUT"
            fi
        fi
    else
        echo "Stay motivated!"
    fi
else
    echo "Stay motivated!"
fi
