{ config, options, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.desktop.kde;

in {
  options.modules.desktop.kde = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ libnotify ];

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
