function brew --description "Wrapper for brew that auto-appends to Brewfile"
    set -l brewfile (set -q HOMEBREW_BUNDLE_FILE; and echo $HOMEBREW_BUNDLE_FILE; or echo "$HOME/.Brewfile")

    command brew $argv
    set -l exit_code $status

    if test $exit_code -eq 0
        switch $argv[1]
            case install
                # Check if it's a cask install
                if contains -- --cask $argv
                    for pkg in $argv[2..-1]
                        # Skip flags
                        string match -q -- '-*' $pkg; and continue
                        # Skip if already in Brewfile
                        grep -q "^cask \"$pkg\"" $brewfile 2>/dev/null; or echo "cask \"$pkg\"" >> $brewfile
                    end
                else
                    for pkg in $argv[2..-1]
                        # Skip flags
                        string match -q -- '-*' $pkg; and continue
                        # Skip if already in Brewfile
                        grep -q "^brew \"$pkg\"" $brewfile 2>/dev/null; or echo "brew \"$pkg\"" >> $brewfile
                    end
                end

            case remove uninstall rm
                if test -f $brewfile
                    if contains -- --cask $argv
                        for pkg in $argv[2..-1]
                            string match -q -- '-*' $pkg; and continue
                            sed -i '' "/^cask \"$pkg\"\$/d" $brewfile
                        end
                    else
                        for pkg in $argv[2..-1]
                            string match -q -- '-*' $pkg; and continue
                            sed -i '' "/^brew \"$pkg\"\$/d" $brewfile
                            sed -i '' "/^cask \"$pkg\"\$/d" $brewfile
                        end
                    end
                end
        end
    end

    return $exit_code
end
