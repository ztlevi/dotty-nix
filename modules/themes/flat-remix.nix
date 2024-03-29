# themes/rainbow/default.nix --- a regal dracula-inspired theme

{ config, options, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.theme;
in {
  config = mkIf (cfg.active == "flat-remix") (mkMerge [
    {
      modules = {
        theme = {
          wallpaper =
            mkDefault "${config.dotfiles.configDir}/wallpapers/pink-1.jpg";
          gtk = {
            theme = "Flat-Remix-GTK-Blue-Light";
            iconTheme = "Flat-Remix-Blue-Light";
            cursorTheme = "Qogir-dark";
            dark = false;
          };
        };
      };
    }

    # Desktop (X11) theming
    (mkIf config.services.xserver.enable {
      # Other themes https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/themes/
      # icons are dumped to /etc/profiles/per-user/$USER/share
      user.packages = with pkgs; [
        flat-remix-gtk
        flat-remix-gnome
        flat-remix-icon-theme
        qogir-icon-theme
      ];

      # Not sure why this section not work anymore
      # home-manager.users.${config.user.name}.home.pointerCursor = {
      #   x11.enable = true;
      #   name = "Qugir-dark";
      #   package = pkgs.qogir-icon-theme;
      #   size = 64;
      # };

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
