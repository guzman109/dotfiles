function cargo --description "Wrapper for cargo that auto-tracks installed crates in Cargofile"
    set -l cargofile "$HOME/.config/homebrew/Cargofile"

    command cargo $argv
    set -l exit_code $status

    if test $exit_code -eq 0
        switch $argv[1]
            case install
                set -l skip_next false
                set -l prev ""
                set -l git_url ""
                set -l git_branch ""
                set -l git_tag ""
                set -l git_rev ""
                set -l crates
                # Flags that take a value argument
                set -l flags_with_values --version --vers --git --branch --tag --rev --path --registry --index --root --target --target-dir --jobs -j --features -F
                for arg in $argv[2..-1]
                    if $skip_next
                        switch $prev
                            case --git
                                set git_url $arg
                            case --branch
                                set git_branch $arg
                            case --tag
                                set git_tag $arg
                            case --rev
                                set git_rev $arg
                        end
                        set skip_next false
                        set prev ""
                        continue
                    end
                    # Skip flags
                    if string match -q -- '-*' $arg
                        # Handle --flag=value form
                        if string match -q -- '*=*' $arg
                            set -l parts (string split -m 1 '=' -- $arg)
                            switch $parts[1]
                                case --git
                                    set git_url $parts[2]
                                case --branch
                                    set git_branch $parts[2]
                                case --tag
                                    set git_tag $parts[2]
                                case --rev
                                    set git_rev $parts[2]
                            end
                        else
                            for flag in $flags_with_values
                                if test "$arg" = "$flag"
                                    set skip_next true
                                    set prev $arg
                                    break
                                end
                            end
                        end
                        continue
                    end
                    set -a crates $arg
                end

                for crate in $crates
                    set -l entry "cargo \"$crate\""
                    if test -n "$git_url"
                        set entry "$entry, git: \"$git_url\""
                    end
                    if test -n "$git_branch"
                        set entry "$entry, branch: \"$git_branch\""
                    end
                    if test -n "$git_tag"
                        set entry "$entry, tag: \"$git_tag\""
                    end
                    if test -n "$git_rev"
                        set entry "$entry, rev: \"$git_rev\""
                    end
                    # Skip if already tracked
                    grep -q "^cargo \"$crate\"" $cargofile 2>/dev/null; or echo $entry >> $cargofile
                end

            case uninstall remove
                if test -f $cargofile
                    for arg in $argv[2..-1]
                        # Skip flags (uninstall only has simple flags, no values)
                        string match -q -- '-*' $arg; and continue
                        if test (uname -s) = Darwin
                            command sed -i '' -E "/^cargo \"$arg\"(,|\$)/d" $cargofile
                        else
                            command sed -i -E "/^cargo \"$arg\"(,|\$)/d" $cargofile
                        end
                    end
                end
        end
    end

    return $exit_code
end
