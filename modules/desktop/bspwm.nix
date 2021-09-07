{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.bspwm;
in {
  options.modules.desktop.bspwm = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    modules.theme.onReload.bspwm = ''
      ${pkgs.bspwm}/bin/bspc wm -r
      ${pkgs.procps}/bin/pkill -USR1 -x sxhkd
    '';

    environment.systemPackages = with pkgs; [
      dunst
      arandr
      libnotify
      (polybar.override {
        pulseSupport = true;
        nlSupport = true;
      })
      # sddm theme
      (my.clairvoyance.override {
        autoFocusPassword = true;
        enableHDPI = true;
        backgroundURL = "https://i.imgur.com/zt68gmt.jpeg";
        sha256 = "0gq2vqgwqnndwkr75b9zfn3hphrp2fdlsxxc6g94n4kkg68ibrbh";
      })
      # apps
      calibre # managing my ebooks
      evince # pdf reader
      feh # image viewer
      mpv # video player
      celluloid # nice GTK GUI for mpv
      gnome.eog # image viewer
      gnome.nautilus # file manager
      gnome.gnome-screenshot # screenshot
      polkit_gnome # polkit
      # gnome control center
      dconf
      gnome.gnome-control-center
      i3lock-color # screen lock
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

    # link recursively so other modules can link files in their folders
    home.configFile = {
      "sxhkd".source = "${config.dotfiles.configDir}/desktop/sxhkd";
      "bspwm/bspwmrc".source = "${config.dotfiles.configDir}/wm/bspwm/bspwmrc";
    };
    env.PATH = [ "${config.dotfiles.configDir}/wm/bspwm/bin" ];
    modules.shell.zsh.rcFiles =
      [ "${config.dotfiles.configDir}/wm/bspwm/rc.zsh" ];
    modules.shell.zsh.envFiles =
      [ "${config.dotfiles.configDir}/wm/bspwm/env.zsh" ];

    console.useXkbConfig = true;
    services = {
      # https://github.com/phillipberndt/autorandr/blob/v1.0/README.md#how-to-use
      # Modify monitor setup with arandr or xrandr
      # autorandr --force --save default && autorandr --default default
      autorandr.enable = true;
      clipmenu.enable = true;
      picom.enable = true;
      xserver = {
        enable = true;
        layout = "us";
        xkbOptions = "ctrl:swapcaps";

        # I'm a window manager user but still lives in Gnome world...
        desktopManager.gnome.enable = true;
        # sddm is a better alternative rather gdm
        displayManager.sddm.enable = true;
        # Clairvoyance theme for sddm https://github.com/JorelAli/nixos/blob/master/README.md
        displayManager.sddm.theme = "clairvoyance";

        windowManager.bspwm.enable = true;
        displayManager.defaultSession = "none+bspwm";

        displayManager.sessionCommands = ''
          if echo ''${XDG_SESSION_DESKTOP} | grep -qi "bspwm"; then
            # Trigger autorandr manually because the service does not work
            ${pkgs.autorandr}/bin/autorandr --change || echo "No autorandr profile found!"

            # xrandr --output DisplayPort-0 --primary --auto  --output DisplayPort-1 --auto --right-of DisplayPort-0 --dpi 144
            RESOLUTION=$(xrandr -q | grep primary | grep ' connected' | cut -d' ' -f4 | cut -d 'x' -f1)
            if [ -z $RESOLUTION ]; then RESOLUTION=1920; fi
            export GDK_SCALE=$(($RESOLUTION / 1920))
            export QT_AUTO_SCREEN_SCALE_FACTOR=0
            export QT_SCALE_FACTOR=$GDK_SCALE

            # revert gnome screen scale settings
            command -v gsettings >/dev/null && gsettings set org.gnome.desktop.interface scaling-factor 1

            if command -v gnome-keyring-daemon >/dev/null; then
              eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)
              export SSH_AUTH_SOCK
            fi

            ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
          fi
        '';
      };
    };
  };
}
