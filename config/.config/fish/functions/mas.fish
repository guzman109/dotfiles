function mas --description "Wrapper for mas that auto-appends to Masfile"
    set -l masfile "$HOME/.config/homebrew/Masfile"

    command mas $argv
    set -l exit_code $status

    if test $exit_code -eq 0
        switch $argv[1]
            case install purchase
                for app_id in $argv[2..-1]
                    string match -q -- '-*' $app_id; and continue
                    # Skip if already in Masfile
                    grep -q "id: $app_id" $masfile 2>/dev/null; and continue
                    # Get app name from mas
                    set -l app_name (command mas info $app_id 2>/dev/null | head -1 | sed 's/ [0-9.]*$//')
                    if test -n "$app_name"
                        echo "mas \"$app_name\", id: $app_id" >> $masfile
                    end
                end

            case uninstall remove
                if test -f $masfile
                    for app_id in $argv[2..-1]
                        string match -q -- '-*' $app_id; and continue
                        sed -i '' "/id: $app_id/d" $masfile
                    end
                end
        end
    end

    return $exit_code
end
