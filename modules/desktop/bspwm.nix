{ config, options, lib, pkgs, ... }:

with lib;
let cfg = config.modules.desktop.bspwm;
in {
  imports = [ ./common.nix ];

  options.modules.desktop.bspwm = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dunst
      arandr
      libnotify
      (polybar.override {
        pulseSupport = true;
        nlSupport = true;
      })

      my.clairvoyance # sddm theme

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
      # https://github.com/phillipberndt/autorandr/blob/v1.0/README.md#how-to-use
      # Modify monitor setup with arandr or xrandr
      # autorandr --force --save default && autorandr --default default
      autorandr.enable = true;
      greenclip.enable = true;
      picom.enable = true;
      redshift.enable = true;
      xserver = {
        enable = true;
        layout = "us";
        xkbOptions = "ctrl:swapcaps";

        # sddm is a better alternative rather gdm
        displayManager.sddm.enable = true;
        # Clairvoyance theme for sddm https://github.com/JorelAli/nixos/blob/master/README.md
        displayManager.sddm.theme = "clairvoyance";

        windowManager.bspwm.enable = true;
        displayManager.defaultSession = "none+bspwm";
        # Use some gnome apps
        desktopManager.gnome3.enable = true;

        displayManager.sessionCommands = ''
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
        '';
      };
    };
  };
}
