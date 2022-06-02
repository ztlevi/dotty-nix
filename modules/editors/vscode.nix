{ config, options, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.editors.vscode;
in {

  options.modules.editors.vscode = { enable = mkBoolOpt false; };
  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      vscode
      (makeDesktopItem {
        name = "VSCode";
        desktopName = "VSCode";
        genericName = "VSCode";
        icon = "visual-studio-code";
        exec =
          "${vscode}/bin/code --enable-features=UseOzonePlatform --ozone-platform=wayland";
        categories = [ "Development" ];
      })
    ];
  };
}
