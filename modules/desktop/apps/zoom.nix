{ config, options, lib, pkgs, ... }:
with lib; {
  options.modules.desktop.apps.zoom = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.apps.zoom.enable {
    my.packages = with pkgs; [ zoom-us ];
  };
}
