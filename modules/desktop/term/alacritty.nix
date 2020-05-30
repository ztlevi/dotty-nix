{ config, lib, pkgs, ... }:

with lib; {
  options.modules.desktop.term.alacritty = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.term.alacritty.enable {
    # xst-256color isn't supported over ssh, so revert to a known one
    my = {
      zsh.rc = ''
        [ "$TERM" = alacritty ] && export TERM=xterm-256color
        ${lib.readFile <config/alacritty/aliases.zsh>}
      '';

      packages = with pkgs; [
        alacritty
        (makeDesktopItem {
          name = "alacritty";
          desktopName = "Alacritty Terminal";
          genericName = "Default terminal";
          icon = "utilities-terminal";
          exec = "${alacritty}/bin/alacritty";
          categories = "Development;System;Utility";
        })
      ];
      home.xdg.configFile = { "alacritty" = { source = <config/alacritty>; }; };
    };
  };
}
