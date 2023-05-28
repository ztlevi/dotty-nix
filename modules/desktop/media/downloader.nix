# modules/desktop/media/docs.nix

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.downloader;
in {
  options.modules.desktop.media.downloader = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
        youtube-dl
        you-get ];

    environment.shellAliases = {
      yg = "you-get";
      yd = "youtube-dl --write-auto-sub --ignore-errors";
      yd2mp4 = "youtube-dl --write-auto-sub --ignore-errors --recode-video mp4";
      yda =
        "youtube-dl -i -o '%(title)s.%(ext)s' --embed-thumbnail --extract-audio --audio-format mp3 --audio-quality 0";
    };
  };
}
