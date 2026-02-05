#!/usr/bin/env fish

# ============ CONFIGURATION ============
set MAX_WIDTH 80
set ICON ""
# =======================================

# Parse arguments
set WRAP_WIDTH 0
set BOX_WIDTH 0
set TYPE_FILTER ""

argparse 'wrap=' 'box=' 'type=' -- $argv
if set -q _flag_wrap
    set WRAP_WIDTH $_flag_wrap
end
if set -q _flag_box
    set BOX_WIDTH $_flag_box
end
if set -q _flag_type
    set TYPE_FILTER $_flag_type
end

set DB_FILE "$HOME/.cache/inspiration/quotes.db"
set TODAY (date +%Y-%m-%d)

if test -f $DB_FILE
    # Get a random quote for today (deterministic based on date)
    set SEED (date +%Y%m%d)

    # Build SQL query with optional type filter
    if test -n "$TYPE_FILTER"
        set TOTAL (sqlite3 $DB_FILE "SELECT COUNT(*) FROM quotes WHERE type='$TYPE_FILTER';" 2>/dev/null)
    else
        set TOTAL (sqlite3 $DB_FILE "SELECT COUNT(*) FROM quotes;" 2>/dev/null)
    end

    if test $TOTAL -gt 0
        # Calculate offset using date as seed (deterministic for the day)
        set OFFSET (math "$SEED % $TOTAL")

        # Get quote with optional type filter
        if test -n "$TYPE_FILTER"
            set RESULT (sqlite3 -separator '|' $DB_FILE \
                "SELECT quote, author FROM quotes WHERE type='$TYPE_FILTER' LIMIT 1 OFFSET $OFFSET;" 2>/dev/null)
        else
            set RESULT (sqlite3 -separator '|' $DB_FILE \
                "SELECT quote, author FROM quotes LIMIT 1 OFFSET $OFFSET;" 2>/dev/null)
        end
    end

    if test -n "$RESULT"
        set QUOTE (echo $RESULT | cut -d'|' -f1)
        set AUTHOR (echo $RESULT | cut -d'|' -f2)

        if test -n "$AUTHOR"; and test "$AUTHOR" != "null"
            set OUTPUT "\"$QUOTE\" — $AUTHOR"
        else
            set OUTPUT "\"$QUOTE\""
        end

        if test $BOX_WIDTH -gt 0
            # Box mode for neovim dashboard
            set INNER_WIDTH (math "$BOX_WIDTH - 4")  # Account for border and padding

            # Wrap the quote text only (without author)
            # Account for icon + space on first line (2 chars)
            set QUOTE_TEXT "\"$QUOTE\""
            set FOLD_WIDTH (math "$INNER_WIDTH - 2")
            set WRAPPED (echo $QUOTE_TEXT | fold -s -w $FOLD_WIDTH)

            # Draw top border
            printf "╭"
            for i in (seq 1 (math "$BOX_WIDTH - 2"))
                printf "─"
            end
            printf "╮\n"

            # Draw wrapped quote lines with side borders (first line has icon)
            set first_line true
            printf '%s\n' $WRAPPED | while read -l line
                if test "$first_line" = "true"
                    # First line: add icon at start
                    set line_with_icon "$ICON $line"
                    set line_len (string length $line_with_icon)
                    set padding (math "$INNER_WIDTH - $line_len")
                    printf "│ %s%*s │\n" $line_with_icon $padding ""
                    set first_line false
                else
                    set line_len (string length $line)
                    set padding (math "$INNER_WIDTH - $line_len")
                    printf "│ %s%*s │\n" $line $padding ""
                end
            end

            # Draw author on separate line (right-aligned with icon)
            if test -n "$AUTHOR"; and test "$AUTHOR" != "null"
                set AUTHOR_LINE "— $AUTHOR $ICON"
                set author_len (string length $AUTHOR_LINE)
                set left_padding (math "$INNER_WIDTH - $author_len")
                printf "│ %*s%s │\n" $left_padding "" $AUTHOR_LINE
            end

            # Draw bottom border
            printf "╰"
            for i in (seq 1 (math "$BOX_WIDTH - 2"))
                printf "─"
            end
            printf "╯\n"
        else if test $WRAP_WIDTH -gt 0
            # Wrap mode
            echo $OUTPUT | fold -s -w $WRAP_WIDTH
        else
            # Truncate mode for starship
            set output_len (string length $OUTPUT)
            if test $output_len -gt $MAX_WIDTH
                set truncate_len (math "$MAX_WIDTH - 3")
                echo (string sub -l $truncate_len $OUTPUT)...
            else
                echo $OUTPUT
            end
        end
    else
        set OUTPUT "Stay motivated!"
        if test $BOX_WIDTH -gt 0
            set INNER_WIDTH (math "$BOX_WIDTH - 4")
            set line_len (string length $OUTPUT)
            set padding (math "$INNER_WIDTH - $line_len")
            printf "╭"
            for i in (seq 1 (math "$BOX_WIDTH - 2"))
                printf "─"
            end
            printf "╮\n"
            printf "│ %s%*s │\n" $OUTPUT $padding ""
            printf "╰"
            for i in (seq 1 (math "$BOX_WIDTH - 2"))
                printf "─"
            end
            printf "╯\n"
        else
            echo $OUTPUT
        end
    end
else
    set OUTPUT "Stay motivated!"
    if test $BOX_WIDTH -gt 0
        set INNER_WIDTH (math "$BOX_WIDTH - 4")
        set line_len (string length $OUTPUT)
        set padding (math "$INNER_WIDTH - $line_len")
        printf "╭"
        for i in (seq 1 (math "$BOX_WIDTH - 2"))
            printf "─"
        end
        printf "╮\n"
        printf "│ %s%*s │\n" $OUTPUT $padding ""
        printf "╰"
        for i in (seq 1 (math "$BOX_WIDTH - 2"))
            printf "─"
        end
        printf "╯\n"
    else
        echo $OUTPUT
    end
end
