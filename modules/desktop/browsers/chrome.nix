# modules/browser/chrome.nix

{ config, options, lib, pkgs, ... }:
with lib; {
  options.modules.desktop.browsers.chrome = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    profileName = mkOption {
      type = types.str;
      default = config.my.username;
    };
  };

  config = mkIf config.modules.desktop.browsers.chrome.enable {
    my.packages = with pkgs; [ google-chrome ];

    my.env.XDG_DESKTOP_DIR = "$HOME"; # (try to) prevent ~/Desktop
  };
}
