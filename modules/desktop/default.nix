{ config, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.desktop;
in {
  config = mkIf config.services.xserver.enable {
    assertions = [
      {
        assertion = (countAttrs (n: v: n == "enable" && value) cfg) < 2;
        message =
          "Can't have more than one desktop environment enabled at a time";
      }
      {
        assertion = let srv = config.services;
        in srv.xserver.enable || srv.sway.enable || !(anyAttrs
          (n: v: isAttrs v && anyAttrs (n: v: isAttrs v && v.enable)) cfg);
        message = "Can't enable a desktop app without a desktop environment";
      }
    ];

    user.packages = with pkgs; [
      calibre # managing my ebooks
      evince # pdf reader
      feh # image viewer
      mpv # video player
      celluloid # nice GTK GUI for mpv
      gnome3.eog # image viewer
      gnome3.nautilus # file manager
      i3lock-color # screen lock
      xclip
      xdotool
      libqalculate # calculator cli w/ currency conversion
      (makeDesktopItem {
        name = "scratch-calc";
        desktopName = "Calculator";
        icon = "calc";
        exec = ''scratch "${tmux}/bin/tmux new-session -s calc -n calc qalc"'';
        categories = "Development";
      })
    ];

    home-manager.users.${config.user.name} = {
      xdg.mimeApps.enable = true;
      # Use get_window_class (xprop) to get the application class name
      # If not sure about the file type, right click and open with selected app, then check ~/.config/mimeapps.list
      xdg.mimeApps.defaultApplications = {
        "audio/mp3" = [ "io.github.celluloid_player.Celluloid.desktop" ];
        "audio/mp4" = [ "io.github.celluloid_player.Celluloid.desktop" ];
        "video/x-avi" = [ "io.github.celluloid_player.Celluloid.desktop" ];
        "video/x-matroska" = [ "io.github.celluloid_player.Celluloid.desktop" ];
        "video/mp4" =
          [ "io.github.celluloid_player.Celluloid.desktop" "mpv.desktop" ];
        "video/mpeg" = [ "io.github.celluloid_player.Celluloid.desktop" ];
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
        "application/x-gnome-saved-search" = [ "org.gnome.Nautilus.desktop" ];
        "image/jpeg" = [ "eog.desktop" ];
        "image/jpg" = [ "eog.desktop" ];
        "image/png" = [ "eog.desktop" ];
        "application/pdf" = [ "org.gnome.Evince.desktop" ];
        "text/x-python" = [ "emacs.desktop" ];
        "torrent" = [ "webtorrent" ];
      };
    };

    ## Sound
    sound.enable = true;
    hardware.pulseaudio.enable = true;

    ## Fonts
    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      fonts = with pkgs; [
        dejavu_fonts
        noto-fonts
        noto-fonts-cjk
        font-awesome-ttf
      ];
      fontconfig.defaultFonts = {
        sansSerif = [ "DejaVu Sans" "Noto Sans CJK SC" "Noto Color Emoji" ];
        serif = [ "DejaVu Serif" "Noto Sans CJK SC" "Noto Color Emoji" ];
        monospace = [ "UbuntuMono Nerd Font Mono" "DejaVu Sans Mono" ];
      };
    };

    services.redshift = {
      enable = true;
      extraOptions = [ "-m randr" ];
    };

    services.xserver = {
      displayManager.lightdm.greeters.mini.user = config.user.name;
    };

    services.picom = {
      backend = "glx";
      vSync = true;
      opacityRules = [
        # "100:class_g = 'Firefox'"
        # "100:class_g = 'Vivaldi-stable'"
        "100:class_g = 'VirtualBox Machine'"
        # Art/image programs where we need fidelity
        "100:class_g = 'Gimp'"
        "100:class_g = 'Inkscape'"
        "100:class_g = 'aseprite'"
        "100:class_g = 'krita'"
        "100:class_g = 'feh'"
        "100:class_g = 'mpv'"
        "100:class_g = 'Rofi'"
        "100:class_g = 'Peek'"
        "99:_NET_WM_STATE@:32a = '_NET_WM_STATE_FULLSCREEN'"
      ];
      shadowExclude = [
        # Put shadows on notifications, the scratch popup and rofi only
        "name *= 'rect-overlay'" # microsoft teams screenshare
        "name ='scratch'"
        "name ='Dunst'"
        "class_g = 'Rofi'"
        "class_g = 'Polybar'"
      ];
      settings.blur-background-exclude = [
        "name *= 'rect-overlay'" # microsoft teams screenshare
        "window_type = 'dock'"
        "window_type = 'desktop'"
        "class_g = 'Rofi'"
        "_GTK_FRAME_EXTENTS@:c"
      ];
    };

    # Try really hard to get QT to respect my GTK theme.
    env.GTK_DATA_PREFIX = [ "${config.system.path}" ];
    env.QT_QPA_PLATFORMTHEME = "gtk2";
    qt5 = {
      style = "gtk2";
      platformTheme = "gtk2";
    };
    services.xserver.displayManager.sessionCommands = ''
      # GTK2_RC_FILES must be available to the display manager.
      export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
    '';

    # Clean up leftovers, as much as we can
    system.userActivationScripts.cleanupHome = ''
      pushd "${homeDir}"
      rm -rf .compose-cache .nv .pki .dbus .fehbg
      rm -f .config/Trolltech.conf
      [ -s .xsession-errors ] || rm -f .xsession-errors*
      rm -f $XDG_CONFIG_HOME/mimeapps.list
      popd
    '';
  };
}
