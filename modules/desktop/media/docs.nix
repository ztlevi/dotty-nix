# modules/desktop/media/docs.nix

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.docs;
in {
  options.modules.desktop.media.docs = {
    pdf.enable = mkBoolOpt false;
    ebook.enable = mkBoolOpt false;
    libreoffice.enable = mkBoolOpt false;
  };

  config = {
    user.packages = with pkgs; [
      (mkIf cfg.ebook.enable calibre)
      (mkIf cfg.pdf.enable evince)
      (mkIf cfg.libreoffice.enable libreoffice-fresh)
    ];
  };
}
