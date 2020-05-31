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
    ];

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
      };
    };

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
  };
}
