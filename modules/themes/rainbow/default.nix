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
          wallpaper = mkDefault ./config/wallpaper.jpg;
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

      fonts.fonts = [ pkgs.nerdfonts ];

      services.picom = {
        fade = true;
        fadeDelta = 5;
        fadeSteps = [ 4.0e-2 8.0e-2 ];
        shadow = true;
        shadowOffsets = [ (-5) (-5) ];
        shadowOpacity = 0.36;
        # activeOpacity = "1.00";
        # inactiveOpacity = "0.90";
        settings = {
          focus-exclude = [ "class_g = 'Rofi'" "class_g = 'Dunst'" ];
          shadow-radius = 10;
          inactive-dim = 0.1;
          # blur-background = true;
          # blur-background-frame = true;
          # blur-background-fixed = true;
          blur-kern = "7x7box";
          blur-strength = 320;
        };
      };

      services.xserver.displayManager.lightdm = {
        greeters.mini.extraConfig = ''
          text-color = "#ff79c6"
          password-background-color = "#1E2029"
          window-color = "#181a23"
          border-color = "#181a23"
        '';
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
