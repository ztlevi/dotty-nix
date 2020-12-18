# modules/desktop/media/recording.nix
#
# OBS to capture footage/stream, audacity for audio, handbrake to encode it all.
# This, paired with DaVinci Resolve for video editing (on my Windows system) and
# I have what I need for youtube videos and streaming.

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.recording;
in {
  options.modules.desktop.media.recording = {
    audio.enable = mkBoolOpt false;
    video.enable = mkBoolOpt false;
  };

  config = {
    user.packages = with pkgs;
    # for recording and remastering audio
      (if cfg.audio.enable then [ audacity ] else [ ]) ++
      # for longer term streaming/recording the screen
      (if cfg.video.enable then [ obs-studio handbrake ] else [ ]);
  };
}
