#!/bin/bash

# ============ CONFIGURATION ============
MAX_WIDTH=80
# =======================================

# Parse arguments
WRAP_WIDTH=0
while [[ $# -gt 0 ]]; do
    case $1 in
        --wrap)
            WRAP_WIDTH="${2:-50}"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

DB_FILE="$HOME/.cache/inspiration/quotes.db"
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
            OUTPUT="\"$QUOTE\" — $AUTHOR"
        else
            OUTPUT="\"$QUOTE\""
        fi

        if [ "$WRAP_WIDTH" -gt 0 ]; then
            # Wrap mode for neovim
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
