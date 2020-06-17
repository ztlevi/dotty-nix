{ config, options, lib, pkgs, ... }:
with lib; {
  imports = [ ./common.nix ];

  options.modules.desktop.bspwm = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.bspwm.enable {
    environment.systemPackages = with pkgs; [
      lightdm
      dunst
      libnotify
      (polybar.override {
        pulseSupport = true;
        nlSupport = true;
      })

      gnome3.nautilus # file manager
      mimeo # mime type settings

      # Use gnome control center
      dconf
      polkit_gnome
    ];

    # link recursively so other modules can link files in their folders
    my = {
      home.xdg.configFile = {
        "sxhkd".source = <config/sxhkd>;
        "bspwm" = {
          source = <config/bspwm>;
          recursive = true;
        };
      };
      env.PATH = [ "$DOTFILES/bin/bspwm" ];
    };

    console.useXkbConfig = true;
    services = {
      picom.enable = true;
      redshift.enable = true;
      xserver = {
        enable = true;
        layout = "us";
        xkbOptions = "ctrl:swapcaps";
        displayManager.defaultSession = "none+bspwm";
        displayManager.lightdm.enable = true;
        # displayManager.lightdm.greeters.mini.enable = true;
        displayManager.lightdm.greeters.enso.enable = true;
        windowManager.bspwm.enable = true;
        desktopManager.gnome3.enable = true;

        # sddm is a better alternative rather gdm
        # displayManager.sddm.enable = true;
        # Clairvoyance theme for sddm https://github.com/JorelAli/nixos/blob/master/README.md
        # displayManager.sddm.theme = "clairvoyance";
        displayManager.sessionCommands = ''
          # xrandr --output DisplayPort-0 --primary --auto  --output DisplayPort-1 --auto --right-of DisplayPort-0 --dpi 144
          RESOLUTION=$(xrandr -q | grep primary | grep ' connected' | cut -d' ' -f4 | cut -d 'x' -f1)
          if [ -z $RESOLUTION ]; then RESOLUTION=1920; fi
          export GDK_SCALE=$(($RESOLUTION / 1920))
          export QT_AUTO_SCREEN_SCALE_FACTOR=0
          export QT_SCALE_FACTOR=$GDK_SCALE

          # revert gnome screen scale settings
          command -v gsettings >/dev/null && gsettings set org.gnome.desktop.interface scaling-factor 1

          if _is_callable gnome-keyring-daemon; then
            eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)
            export SSH_AUTH_SOCK
          fi

          _call ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &

          _call ${pkgs.mimeo}/bin/mimeo --prefer io.github.celluloid_player.Celluloid.desktop eog.desktop nautilus.desktop
        '';
      };
    };
  };
}
