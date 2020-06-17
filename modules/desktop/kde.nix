{ config, options, lib, pkgs, ... }:
with lib; {
  imports = [ ./common.nix ];

  options.modules.desktop.kde = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.kde.enable {
    environment.systemPackages = with pkgs; [ libnotify ];

    # link recursively so other modules can link files in their folders
    # my = {
    #   home.xdg.configFile = {
    #     "sxhkd".source = <config/sxhkd>;
    #     "bspwm" = {
    #       source = <config/bspwm>;
    #       recursive = true;
    #     };
    #   };
    #   env.PATH = [ "$DOTFILES/bin/bspwm" ];
    # };

    console.useXkbConfig = true;
    services = {
      picom.enable = false;
      redshift.enable = true;
      xserver = {
        enable = true;
        layout = "us";
        xkbOptions = "ctrl:swapcaps";
        displayManager.sddm.enable = true;
        desktopManager.plasma5.enable = true;

        # Clairvoyance theme for sddm https://github.com/JorelAli/nixos/blob/master/README.md
        # displayManager.sddm.theme = "clairvoyance";
        displayManager.sessionCommands = "";
      };
    };
    # programs.ssh.askPassword =
    #   pkgs.lib.mkForce "${pkgs.plasma5.ksshaskpass.out}/bin/ksshaskpass";

  };
}
