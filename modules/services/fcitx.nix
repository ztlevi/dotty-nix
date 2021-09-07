{ config, options, pkgs, lib, ... }:
with lib;
with lib.my;
let cfg = config.modules.services.fcitx;
in {
  options.modules.services.fcitx = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    i18n.inputMethod.enabled = "fcitx";
    i18n.inputMethod.fcitx.engines = with pkgs.fcitx-engines; [ rime ];
    # Fcitx configs need to be writable, use home.configFile will make the config folder read only
  };
}
