{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.rofi;
in {
  options.modules.desktop.apps.rofi = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    env.PATH = [ "${config.dotfiles.configDir}/desktop/rofi/bin" ];
    home.configFile."rofi" = {
      source = "${config.dotfiles.configDir}/desktop/rofi";
      recursive = true;
    };

    user.packages = with pkgs; [
      (writeScriptBin "rofi" ''
        #!${stdenv.shell}
        exec ${rofi-unwrapped}/bin/rofi -terminal alacritty -m -1 "$@"
      '')

      # Fake rofi dmenu entries
      (makeDesktopItem {
        name = "rofi-browsermenu";
        desktopName = "Open Bookmark in Browser";
        icon = "bookmark-new-symbolic";
        exec = "${config.dotfiles.configDir}/desktop/rofi/bin/browsermenu";
      })
      (makeDesktopItem {
        name = "rofi-browsermenu-history";
        desktopName = "Open Browser History";
        icon = "accessories-clock";
        exec =
          "${config.dotfiles.configDir}/desktop/rofi/bin/browsermenu history";
      })
      (makeDesktopItem {
        name = "rofi-filemenu";
        desktopName = "Open Directory in Terminal";
        icon = "folder";
        exec = "${config.dotfiles.configDir}/desktop/rofi/bin/filemenu";
      })
      (makeDesktopItem {
        name = "rofi-filemenu-scratch";
        desktopName = "Open Directory in Scratch Terminal";
        icon = "folder";
        exec = "${config.dotfiles.configDir}/desktop/rofi/bin/filemenu -x";
      })

      (makeDesktopItem {
        name = "lock-display";
        desktopName = "Lock screen";
        icon = "system-lock-screen";
        exec = "${config.dotfiles.binDir}/zzz";
      })
    ];
  };
}
