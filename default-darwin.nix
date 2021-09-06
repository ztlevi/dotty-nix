{ inputs, config, lib, pkgs, ... }:

with lib;
with lib.my;
with inputs; {
  imports = [
    home-manager.darwinModules.home-manager
    ./darwin/options.nix
    ./darwin/xdg.nix
  ];

  nix = {
    package = pkgs.nixFlakes;
    # Automatically detects files in the store that have identical contents.
    # Users that have additional rights when connecting to the Nix daemon.
    trustedUsers = [ "root" "@wheel" config.user.name ];
    gc = {
      # Automatically run the Nix garbage collector daily.
      automatic = true;
      # Run the collector as the current user.
      user = config.user.name;
      options = "--delete-older-than 10d";
    };
    extraOptions = "experimental-features = nix-command flakes";
    nixPath = [
      "nixpkgs=${nixpkgs}"
      "nixpkgs-overlays=${config.dotfiles.dir}/overlays"
      "home-manager=${home-manager}"
      "dotfiles=${config.dotfiles.dir}"
    ];
    binaryCaches =
      [ "https://cache.nixos.org/" "https://nix-community.cachix.org" ];
    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    # registry = { nixpkgs.flake = nixpkgs; };
    useSandbox = true;
  };
  # Common config for all nixos machines; and to ensure the flake operates
  # soundly
  environment.variables.DOTTY_HOME = config.dotfiles.dir;
  environment.variables.DOTTY_ASSETS_HOME = dotAssetDir;

  # Configure nix and nixpkgs
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [ vim vscodium ];

  # Auto-upgrade the daemon service.
  # services.nix-daemon.enable = true;
  # services.nix-daemon.enableSocketListener = true;

  # Install per-user packages.
  # home-manager.useUserPackages = true;

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Create /etc/bashrc that loads the nix-darwin environment.
  # FIXME: remove when home-manager zsh is usable
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
