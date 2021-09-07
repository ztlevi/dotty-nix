{ config, options, pkgs, lib, ... }:
with lib;
with lib.my;
let cfg = config.modules.services.fcitx;
in {
  options.modules.services.fcitx = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-rime
        fcitx5-chinese-addons
        fcitx5-gtk
        libsForQt5.fcitx5-qt
      ];
    };
  };
}
