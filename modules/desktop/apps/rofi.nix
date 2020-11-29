{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.rofi;
in {
  options.modules.desktop.apps.rofi = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    # link recursively so other modules can link files in its folder
    # home.xdg.configFile."rofi" = {
    #   source = <config/rofi>;
    #   recursive = true;
    # };

    env.PATH = [ "${configDir}/rofi/bin" "$PATH" ];
    home.configFile."rofi" = {
      source = "${configDir}/rofi";
      recursive = true;
    };

    user.packages = with pkgs; [
      (writeScriptBin "rofi" ''
        #!${stdenv.shell}
        exec ${rofi-unwrapped}/bin/rofi -terminal alacritty -m -1 "$@"
      '')

      # For rapidly test changes to rofi's stylesheets
      # (writeScriptBin "rofi-test" ''
      #   #!${stdenv.shell}
      #   themefile=$1
      #   themename=${modules.theme.name}
      #   shift
      #   exec rofi \
      #        -theme ~/.config/dotfiles/modules/themes/$themename/rofi/$themefile \
      #        "$@"
      #   '')

      # Fake rofi dmenu entries
      (makeDesktopItem {
        name = "rofi-bookmarkmenu";
        desktopName = "Open Bookmark in Browser";
        icon = "bookmark-new-symbolic";
        exec = "${configDir}/rofi/bin/bookmarkmenu";
      })
      (makeDesktopItem {
        name = "rofi-filemenu";
        desktopName = "Open Directory in Terminal";
        icon = "folder";
        exec = "${configDir}/rofi/bin/filemenu";
      })
      (makeDesktopItem {
        name = "rofi-filemenu-scratch";
        desktopName = "Open Directory in Scratch Terminal";
        icon = "folder";
        exec = "${configDir}/rofi/bin/filemenu -x";
      })

      (makeDesktopItem {
        name = "lock-display";
        desktopName = "Lock screen";
        icon = "system-lock-screen";
        exec = "${binDir}/zzz";
      })
    ];
  };
}
