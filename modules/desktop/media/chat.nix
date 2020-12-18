# modules/desktop/media/chat.nix

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.chat;
in {
  options.modules.desktop.media.chat = {
    telegram.enable = mkBoolOpt false;
    discord.enable = mkBoolOpt false;
    skype.enable = mkBoolOpt false;
    zoom.enable = mkBoolOpt false;
  };

  config = {
    user.packages = with pkgs;
      lib.flatten [
        (mkIf cfg.telegram.enable tdesktop)
        (mkIf cfg.discord.enable discord)
        (mkIf cfg.skype.enable [ skypeforlinux skype_call_recorder ])
        (mkIf cfg.zoom.enable zoom-us)
      ];
  };
}
