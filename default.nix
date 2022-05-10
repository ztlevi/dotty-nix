{ inputs, config, lib, pkgs, ... }:

with lib;
with lib.my; {
  imports =
    # I use home-manager to deploy files to $HOME; little else
    [
      inputs.home-manager.nixosModules.home-manager
    ]
    # All my personal modules
    ++ (mapModulesRec' (toString ./modules) import);

  # Common config for all nixos machines; and to ensure the flake operates
  # soundly
  environment.variables.DOTTY_HOME = config.dotfiles.dir;
  environment.variables.DOTTY_BIN_HOME = config.dotfiles.binDir;
  environment.variables.DOTTY_CONFIG_HOME = config.dotfiles.configDir;
  environment.variables.DOTTY_ASSETS_HOME = config.dotfiles.assetsDir;

  # Configure nix and nixpkgs
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
  nix = let
    filteredInputs = filterAttrs (n: _: n != "self") inputs;
    nixPathInputs = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
    registryInputs = mapAttrs (_: v: { flake = v; }) filteredInputs;
  in {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    gc = {
      automatic = true;
      options = "--delete-older-than 8d";
    };
    nixPath = nixPathInputs ++ [
      "nixpkgs-overlays=${config.dotfiles.dir}/overlays"
      "dotfiles=${config.dotfiles.dir}"
    ];
    binaryCaches = [ "https://nix-community.cachix.org" ];
    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    registry = registryInputs // { dotfiles.flake = inputs.self; };
    autoOptimiseStore = true;
  };
  system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;
  system.stateVersion = "22.05";

  ## Some reasonable, global defaults
  # This is here to appease 'nix flake check' for generic hosts with no
  # hardware-configuration.nix or fileSystem config.
  fileSystems."/".device = mkDefault "/dev/disk/by-label/nixos";

  # boot.kernelPackages = pkgs.linuxPackages_latest;

  boot = {
    kernelPackages = mkDefault pkgs.linuxPackages_5_17;
    loader = {
      efi.canTouchEfiVariables = mkDefault true;
      systemd-boot.configurationLimit = 10;
      systemd-boot.enable = mkDefault true;
    };
  };

  # Just the bear necessities...
  environment.systemPackages = with pkgs; [
    cached-nix-shell
    coreutils
    git
    vim
    wget
    curl
    fd
    gnumake
    nixfmt
    lshw

    killall
    unzip
    sshfs
  ];
}
