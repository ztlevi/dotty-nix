# themes/rainbow/default.nix --- a regal dracula-inspired theme

{ config, options, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.theme;
in {
  config = mkIf (cfg.active == "rainbow") (mkMerge [
    {
      modules = {
        theme = {
          wallpaper =
            mkDefault "${config.dotfiles.configDir}/wallpapers/pink-1.jpg";
          gtk = {
            theme = "Flat-Remix-GTK-Blue";
            iconTheme = "Flat-Remix-Blue";
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
      user.packages = with pkgs; [ flat-remix-gtk flat-remix-icon-theme ];

      home-manager.users.${config.user.name}.xsession.pointerCursor = {
        name = "capitaine-cursors-white";
        package = pkgs.capitaine-cursors;
        size = 64;
      };

      home.configFile = with config.modules;
        mkMerge [
          {
            # Sourced from sessionCommands in modules/themes/default.nix
            "xtheme/90-theme".source =
              "${config.dotfiles.configDir}/wm/general/Xresources";
          }
          (mkIf (desktop.bspwm.enable) {
            "polybar" = {
              source = "${config.dotfiles.configDir}/desktop/polybar";
              recursive = true;
            };
            "dunst/dunstrc".source =
              "${config.dotfiles.configDir}/desktop/dunst/dunstrc";
          })
        ];
    })
  ]);
}
