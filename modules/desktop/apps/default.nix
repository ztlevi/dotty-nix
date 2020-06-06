{ config, lib, pkgs, ... }:

{
  imports = [
    ./daw.nix
    ./discord.nix
    ./telegram.nix
    ./graphics.nix
    ./recording.nix
    ./rofi.nix
    ./skype.nix
    ./vm.nix
  ];
}
