{ config, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ];

  nix = {
    package = pkgs.nix;
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
  };

  nixpkgs.overlays = import ./packages;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [ ];

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

  # Default settings for primary user account. `my` is defined in
  # ./options.nix
  my.user = {
    uid = 1000;
    shell = pkgs.zsh;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
