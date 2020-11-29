{ config, options, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.desktop.apps.libreoffice;
in {
  options.modules.desktop.apps.libreoffice = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs;
      [
        libreoffice-fresh
        # wpsoffice
      ];
  };
}
