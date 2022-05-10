{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.term.alacritty;
in {
  options.modules.desktop.term.alacritty = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    modules.shell.zsh.rcFiles =
      [ "${config.dotfiles.configDir}/shell/alacritty/rc.zsh" ];
    modules.shell.zsh.envFiles =
      [ "${config.dotfiles.configDir}/shell/alacritty/env.zsh" ];

    user.packages = with pkgs; [
      alacritty
      (makeDesktopItem {
        name = "alacritty";
        desktopName = "Alacritty Terminal";
        genericName = "Default terminal";
        icon = "utilities-terminal";
        exec = "env WAYLAND_DISPLAY= ${alacritty}/bin/alacritty";
        categories = [ "Development" "System" "Utility" ];
      })
      vivid
    ];
    home.configFile = {
      "alacritty/alacritty.yml" = {
        source =
          "${config.dotfiles.configDir}/shell/alacritty/config/nixos-alacritty.yml";
      };
    };
  };
}
