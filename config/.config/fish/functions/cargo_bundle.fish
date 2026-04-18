function cargo_bundle --description "Install all crates listed in Cargofile"
    set -l cargofile "$HOME/.config/homebrew/Cargofile"
    if not test -f $cargofile
        echo "Cargofile not found at $cargofile" >&2
        return 1
    end

    while read -l line
        set line (string trim -- $line)
        test -z "$line"; and continue
        string match -q -- '#*' $line; and continue

        set -l body (string replace -r '^cargo +' '' -- $line)
        set -l parts (string split ', ' -- $body)

        set -l name (string trim -c '"' -- $parts[1])
        set -l args $name
        if test (count $parts) -gt 1
            for part in $parts[2..-1]
                set -l kv (string split -m 1 ': ' -- $part)
                set -a args --$kv[1] (string trim -c '"' -- $kv[2])
            end
        end

        echo "==> cargo install $args"
        command cargo install $args
    end < $cargofile
end
