{ config, options, lib, pkgs, ... }:
with lib; {
  options.modules.desktop.apps.libreoffice = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.apps.libreoffice.enable {
    my.packages = with pkgs;
      [
        libreoffice-fresh
        # wpsoffice
      ];
  };
}
