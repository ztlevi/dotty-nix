# modules/browser/chrome.nix

{ config, options, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.desktop.browsers.chrome;
in {
  options.modules.desktop.browsers.chrome = {
    enable = mkBoolOpt false;
    profileName = mkOpt types.str config.user.name;
  };

  config = mkIf cfg.enable { user.packages = with pkgs; [ google-chrome ]; };
}
