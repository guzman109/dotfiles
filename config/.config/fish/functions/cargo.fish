function cargo --description "Wrapper for cargo that auto-tracks installed crates in Cargofile"
    set -l cargofile "$HOME/.config/homebrew/Cargofile"

    command cargo $argv
    set -l exit_code $status

    if test $exit_code -eq 0
        switch $argv[1]
            case install
                set -l skip_next false
                # Flags that take a value argument
                set -l flags_with_values --version --vers --git --branch --tag --rev --path --registry --index --root --target --target-dir --jobs -j --features -F
                for arg in $argv[2..-1]
                    if $skip_next
                        set skip_next false
                        continue
                    end
                    # Skip flags
                    if string match -q -- '-*' $arg
                        # Check if this flag takes a value (and value is separate, not --flag=value)
                        if not string match -q '*=*' $arg
                            for flag in $flags_with_values
                                if test "$arg" = "$flag"
                                    set skip_next true
                                    break
                                end
                            end
                        end
                        continue
                    end
                    # Skip if already tracked
                    grep -q "^cargo \"$arg\"" $cargofile 2>/dev/null; or echo "cargo \"$arg\"" >> $cargofile
                end

            case uninstall remove
                if test -f $cargofile
                    for arg in $argv[2..-1]
                        # Skip flags (uninstall only has simple flags, no values)
                        string match -q -- '-*' $arg; and continue
                        sed -i '' "/^cargo \"$arg\"\$/d" $cargofile
                    end
                end
        end
    end

    return $exit_code
end
