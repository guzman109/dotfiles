function __dotfiles_require_macos --description "Return non-zero with a message when called outside macOS"
    if test (uname -s) = Darwin
        return 0
    end

    echo "$argv[1] is only supported on macOS." >&2
    return 1
end
