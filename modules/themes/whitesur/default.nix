# themes/rainbow/default.nix --- a regal dracula-inspired theme

{ config, options, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.theme;
in {
  config = mkIf (cfg.active == "whitesur") (mkMerge [
    {
      modules = {
        theme = {
          # This is useless, wallpaper for gnome is set by dconf
          wallpaper =
            mkDefault "${config.dotfiles.assetsDir}/wallpapers/pink-2.jpg";
          gtk = {
            theme = "WhiteSur-light-blue";
            iconTheme = "WhiteSur";
            cursorTheme = "capitaine-cursors-white";
            dark = false;
          };
        };
      };
    }

    # Desktop (X11) theming
    (mkIf config.services.xserver.enable {
      # Other themes https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/themes/
      # icons are dumped to /etc/profiles/per-user/$USER/share
      user.packages = with pkgs; [ whitesur-gtk-theme whitesur-icon-theme ];

      home-manager.users.${config.user.name}.xsession.pointerCursor = {
        name = "capitaine-cursors-white";
        package = pkgs.capitaine-cursors;
        size = 64;
      };

      home.configFile = with config.modules;
        mkMerge [{
          # Sourced from sessionCommands in modules/themes/default.nix
          "xtheme/90-theme".source =
            "${config.dotfiles.configDir}/wm/general/Xresources";
        }];
    })
  ]);
}
