{ inputs, config, lib, pkgs, ... }:

let
  inherit (lib) optional optionals flatten;
  inherit (lib.systems.elaborate { system = builtins.currentSystem; })
    isLinux isDarwin;
  pwd = builtins.toPath ./.;
in {

  imports = flatten [
    (optionals isDarwin [ ./darwin-configuration.nix ])
    (optionals isLinux [ (import ./nixos-configuration.nix) ])
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
    dots = "make -C ~/.config/dotfiles";
    nr = "nix repl '<nixpkgs>'";
  };
}
