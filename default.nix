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
{ pkgs, options, lib, config, ... }:
let
  inherit (lib) optional optionals flatten;
  inherit (lib.systems.elaborate { system = builtins.currentSystem; })
    isLinux isDarwin;
  pwd = builtins.toPath ./.;
in {
  networking.hostName = lib.mkDefault device;
  my.username = username;

  imports = flatten [
    ./options.nix
    (optionals isDarwin [ ./darwin-configuration.nix ])
    (optionals isLinux
      [ (import ./nixos-configuration.nix "${device}" "${username}") ])
    (optional (builtins.pathExists /etc/nixos/cachix.nix) /etc/nixos/cachix.nix)
  ];

  ### NixOS
  nix = {
    nixPath = options.nix.nixPath.default ++ [
      # So we can use absolute import paths
      "bin=/etc/dotfiles/bin/"
      "config=/etc/dotfiles/config/"
    ];
  };

  # Add custom packages & unstable channel, so they can be accessed via pkgs.*
  nixpkgs.config.allowUnfree = true; # forgive me Stallman senpai

  # These are the things I want installed on all my systems
  environment.systemPackages = with pkgs; [
    # Just the bear necessities~
    git
    vim
    wget
    curl
    nixfmt
    fd
    gnumake # for our own makefile
    cachix # less time buildin' mo time nixin'
  ];
  environment.shellAliases = {
    nix-env = "NIXPKGS_ALLOW_UNFREE=1 nix-env";
    nsh = "nix-shell";
    nen = "nix-env";
    dots = "make -C ~/.dotfiles";
    nr = "nix repl '<nixpkgs>'";
  };
}
