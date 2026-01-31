function brew --description "Wrapper for brew that auto-appends to separate files"
    set -l configdir "$HOME/.config/homebrew"
    set -l brewfile "$configdir/Brewfile"
    set -l caskfile "$configdir/BrewCaskfile"
    set -l tapfile "$configdir/BrewTapfile"

    command brew $argv
    set -l exit_code $status

    if test $exit_code -eq 0
        switch $argv[1]
            case install
                # Check if it's a cask install
                if contains -- --cask $argv
                    for pkg in $argv[2..-1]
                        string match -q -- '-*' $pkg; and continue
                        grep -q "^cask \"$pkg\"" $caskfile 2>/dev/null; or echo "cask \"$pkg\"" >> $caskfile
                    end
                else
                    for pkg in $argv[2..-1]
                        string match -q -- '-*' $pkg; and continue
                        # Packages from taps (contain /) go to tapfile
                        if string match -q '*/*' $pkg
                            grep -q "^brew \"$pkg\"" $tapfile 2>/dev/null; or echo "brew \"$pkg\"" >> $tapfile
                        else
                            grep -q "^brew \"$pkg\"" $brewfile 2>/dev/null; or echo "brew \"$pkg\"" >> $brewfile
                        end
                    end
                end

            case remove uninstall rm
                if contains -- --cask $argv
                    for pkg in $argv[2..-1]
                        string match -q -- '-*' $pkg; and continue
                        test -f $caskfile; and sed -i '' "/^cask \"$pkg\"\$/d" $caskfile
                    end
                else
                    for pkg in $argv[2..-1]
                        string match -q -- '-*' $pkg; and continue
                        # Packages from taps (contain /) are in tapfile
                        if string match -q '*/*' $pkg
                            test -f $tapfile; and sed -i '' "/^brew \"$pkg\"\$/d" $tapfile
                        else
                            test -f $brewfile; and sed -i '' "/^brew \"$pkg\"\$/d" $brewfile
                            test -f $caskfile; and sed -i '' "/^cask \"$pkg\"\$/d" $caskfile
                        end
                    end
                end

            case tap
                for t in $argv[2..-1]
                    string match -q -- '-*' $t; and continue
                    grep -q "^tap \"$t\"" $tapfile 2>/dev/null; or echo "tap \"$t\"" >> $tapfile
                end

            case untap
                if test -f $tapfile
                    for t in $argv[2..-1]
                        string match -q -- '-*' $t; and continue
                        # Remove the tap entry
                        sed -i '' "/^tap \"$t\"\$/d" $tapfile
                        # Remove any brew packages from this tap (e.g., brew "oven-sh/bun/...")
                        sed -i '' "/^brew \"$t\//d" $tapfile
                    end
                end
        end
    end

    return $exit_code
end
