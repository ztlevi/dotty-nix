{ config, lib, pkgs, ... }:

{
  imports = [
    ./bspwm.nix
    ./kde.nix

    ./apps
    ./term
    ./browsers
    ./gaming
  ];
}
