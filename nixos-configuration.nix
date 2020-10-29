# default.nix --- the heart of my dotfiles
#
# Author:  Henrik Lissner <henrik@lissner.net>
# URL:     https://github.com/ztlevi/nix-dotfiles
# License: MIT
#
# This is ground zero, where the absolute essentials go, to be present on all
# systems I use nixos on. Most of which are single user systems (the ones that
# aren't are configured from their hosts/*/default.nix).

device: username:
{ pkgs, options, lib, config, ... }: {
  # These are the things I want installed on all my systems
  imports = [ <home-manager/nixos> ./modules "${./hosts}/${device}" ];

  nix = {
    autoOptimiseStore = true;
    # Automatically detects files in the store that have identical contents.
    # Users that have additional rights when connecting to the Nix daemon.
    trustedUsers = [ "root" "@wheel" config.my.username ];

    gc = {
      # Automatically run the Nix garbage collector daily.
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 10d";
    };
  };

  nixpkgs.overlays = import ./packages;

  environment.systemPackages = with pkgs; [
    # Just the bear necessities~
    coreutils
    killall
    unzip
    sshfs
    unstable.cached-nix-shell
    (writeScriptBin "nix-shell" ''
      #!${stdenv.shell}
      NIX_PATH="nixpkgs-overlays=/etc/dotfiles/packages/default.nix:$NIX_PATH" ${nix}/bin/nix-shell "$@"
    '')
  ];

  # Default settings for primary user account. `my` is defined in
  # ./options.nix
  my.user = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "video" "networkmanager" ];
    shell = pkgs.zsh;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09"; # Did you read the comment?
}
