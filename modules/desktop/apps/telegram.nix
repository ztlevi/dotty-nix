{ config, options, lib, pkgs, ... }:
with lib; {
  options.modules.desktop.apps.telegram = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.apps.telegram.enable {
    my.packages = with pkgs; [ tdesktop ];
  };
}
