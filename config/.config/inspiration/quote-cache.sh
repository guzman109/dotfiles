#!/bin/bash

# ============ CONFIGURATION ============
MAX_WIDTH=80
ICON=""
# =======================================

# Parse arguments
WRAP_WIDTH=0
BOX_WIDTH=0
while [[ $# -gt 0 ]]; do
    case $1 in
        --wrap)
            WRAP_WIDTH="${2:-50}"
            shift 2
            ;;
        --box)
            BOX_WIDTH="${2:-50}"
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

        if [ "$BOX_WIDTH" -gt 0 ]; then
            # Box mode for neovim dashboard
            INNER_WIDTH=$((BOX_WIDTH - 4))  # Account for border and padding

            # Wrap the quote text only (without author)
            QUOTE_TEXT="\"$QUOTE\""
            WRAPPED=$(echo "$QUOTE_TEXT" | fold -s -w "$INNER_WIDTH")

            # Draw top border
            printf "╭"
            printf '─%.0s' $(seq 1 $((BOX_WIDTH - 2)))
            printf "╮\n"

            # Draw wrapped quote lines with side borders (first line has icon)
            first_line=true
            while IFS= read -r line; do
                if $first_line; then
                    # First line: add icon at start
                    line_with_icon="$ICON $line"
                    line_len=${#line_with_icon}
                    padding=$((INNER_WIDTH - line_len))
                    printf "│ %s%*s │\n" "$line_with_icon" "$padding" ""
                    first_line=false
                else
                    line_len=${#line}
                    padding=$((INNER_WIDTH - line_len))
                    printf "│ %s%*s │\n" "$line" "$padding" ""
                fi
            done <<< "$WRAPPED"

            # Draw author on separate line (right-aligned with icon)
            if [ -n "$AUTHOR" ] && [ "$AUTHOR" != "null" ]; then
                AUTHOR_LINE="— $AUTHOR $ICON"
                author_len=${#AUTHOR_LINE}
                left_padding=$((INNER_WIDTH - author_len))
                printf "│ %*s%s │\n" "$left_padding" "" "$AUTHOR_LINE"
            fi

            # Draw bottom border
            printf "╰"
            printf '─%.0s' $(seq 1 $((BOX_WIDTH - 2)))
            printf "╯\n"
        elif [ "$WRAP_WIDTH" -gt 0 ]; then
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
        OUTPUT="Stay motivated!"
        if [ "$BOX_WIDTH" -gt 0 ]; then
            INNER_WIDTH=$((BOX_WIDTH - 4))
            line_len=${#OUTPUT}
            padding=$((INNER_WIDTH - line_len))
            printf "╭"
            printf '─%.0s' $(seq 1 $((BOX_WIDTH - 2)))
            printf "╮\n"
            printf "│ %s%*s │\n" "$OUTPUT" "$padding" ""
            printf "╰"
            printf '─%.0s' $(seq 1 $((BOX_WIDTH - 2)))
            printf "╯\n"
        else
            echo "$OUTPUT"
        fi
    fi
else
    OUTPUT="Stay motivated!"
    if [ "$BOX_WIDTH" -gt 0 ]; then
        INNER_WIDTH=$((BOX_WIDTH - 4))
        line_len=${#OUTPUT}
        padding=$((INNER_WIDTH - line_len))
        printf "╭"
        printf '─%.0s' $(seq 1 $((BOX_WIDTH - 2)))
        printf "╮\n"
        printf "│ %s%*s │\n" "$OUTPUT" "$padding" ""
        printf "╰"
        printf '─%.0s' $(seq 1 $((BOX_WIDTH - 2)))
        printf "╯\n"
    else
        echo "$OUTPUT"
    fi
fi
