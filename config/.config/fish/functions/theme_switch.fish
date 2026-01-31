function theme_switch
    # Reload Fish to pick up theme changes from background service
    echo "Reloading shell with current theme..."
    exec fish
end
