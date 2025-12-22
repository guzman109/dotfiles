{
  description = "M4 System Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    nix-homebrew,
  }: let
    configuration = {pkgs, ...}: {
      system.primaryUser = "guzman.109";
      nixpkgs.config.allowUnfree = true;
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [
        # A
        # B
        pkgs.bat
        pkgs.btop
          pkgs.bun
        # C
        pkgs.cmake
        pkgs.conan
        # D
        pkgs.dbeaver-bin
        # E
        pkgs.eza
        # F
        pkgs.fd
        pkgs.fishMinimal
        pkgs.fzf
        # G
        pkgs.gh
        pkgs.ghostscript
        pkgs.git
        pkgs.git-lfs
        pkgs.grpcurl
        # H
        # I
        pkgs.imagemagick
        # J
        pkgs.just
        # K
        pkgs.kitty
        # L
        pkgs.lazygit
        # M
        # N
        pkgs.neovim
        pkgs.ninja
        # O
        # P
        # Q
        # R
        pkgs.ripgrep
        # S
        pkgs.starship
        pkgs.stow
        # T
        pkgs.tree
        pkgs.tree-sitter
        # U
          pkgs.uv
        # V
        # W
        pkgs.websocat
        pkgs.wimlib
        # X
        # Y
        # Z
        pkgs.zig
      ];

      homebrew = {
        enable = true;
        brews = [
          "luarocks"
          "mas"
        ];
        casks = [
          "balenaetcher"
          "lookaway"
          "pearcleaner"
        ];
        masApps = {
          "BearNotes" = 1091189122;
          "CotEditor" = 1024640650;
          "Noir" = 1592917505;
          "OwlFiles" = 510282524;
          "Wipr2" = 1662217862;
        };
        onActivation = {
          autoUpdate = true;
          upgrade = true;
          cleanup = "zap";
        };
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Carloss-MacBook-Pro
    darwinConfigurations."Carloss-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "guzman.109";
            autoMigrate = true;
          };
        }
      ];
    };
  };
}
