{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.term.alacritty;
in {
  options.modules.desktop.term.alacritty = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    # xst-256color isn't supported over ssh, so revert to a known one
    modules.shell.zsh.rcInit =
      ''[ "$TERM" = xst-256color ] && export TERM=xterm-256color'';

    modules.shell.zsh.rcFiles = [ "${configDirBackup}/alacritty/aliases.zsh" ];

    user.packages = with pkgs; [
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
    home.configFile = { "alacritty" = { source = "${configDirBackup}/alacritty"; }; };
  };
}
