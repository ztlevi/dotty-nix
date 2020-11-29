{ config, options, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.desktop.apps.telegram;
in {
  options.modules.desktop.apps.telegram = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable { user.packages = with pkgs; [ tdesktop ]; };
}
