function __dotfiles_delete_line --description "Delete matching lines from a file with portable sed flags"
    set -l pattern $argv[1]
    set -l file $argv[2]

    if test -z "$pattern" -o -z "$file"
        return 1
    end

    if not test -f $file
        return 0
    end

    if test (uname -s) = Darwin
        command sed -i '' "$pattern" $file
    else
        command sed -i "$pattern" $file
    end
end
