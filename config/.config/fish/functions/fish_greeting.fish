function fish_greeting
    set -l quote_script $HOME/.config/inspiration/quote-cache.fish
    set -l box_width 72

    if set -q COLUMNS; and test $COLUMNS -gt 0
        set box_width (math "min(88, max(44, $COLUMNS - 4))")
    end

    if test -x $quote_script
        echo
        $quote_script --box=$box_width --type=motivation
        echo
    else
        echo
        echo "󰓎 Stay motivated!"
        echo
    end
end
