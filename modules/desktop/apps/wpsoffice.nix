{ config, options, lib, pkgs, ... }:
with lib; {
  options.modules.desktop.apps.wpsoffice = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.apps.wpsoffice.enable {
    my.packages = with pkgs; [ wpsoffice ];
  };
}
