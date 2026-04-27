function bundle_all --description "Install everything from all bundle files (Brew, Cask, Tap, Mas, Cargo)"
    __dotfiles_require_macos bundle_all; or return 1

    set -l homebrew_dir "$HOME/.config/homebrew"

    for name in BrewTapfile Brewfile BrewCaskfile Masfile
        set -l file "$homebrew_dir/$name"
        if test -f $file
            printf "==> brew bundle --file=%s\n" $file
            command brew bundle --file=$file; or return $status
        else
            printf "Skipping %s (not found)\n" $file >&2
        end
    end

    printf "==> cargo_bundle\n"
    cargo_bundle
end
