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
      # icons are dumped to /etc/profiles/per-user/$USER/share
      user.packages = with pkgs; [
        my.flat-remix-gtk
        flat-remix-icon-theme
        # papirus-icon-theme
        # my.ant-dracula
        # materia-theme # "Materia-light-compact"
        # paper-icon-theme # for both cursor and icon
      ];

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

      home = with config.modules; {
        file = mkMerge [
          (mkIf desktop.browsers.firefox.enable {
            ".mozilla/firefox/${desktop.browsers.firefox.profileName}.default/chrome/userChrome.css" =
              {
                source = ./firefox/userChrome.css;
              };
          })
        ];
        configFile = mkMerge [
          (mkIf config.services.xserver.enable {
            "xtheme/90-theme".source = ./config/Xresources;
          })
          (mkIf desktop.bspwm.enable {
            "bspwm/rc.d/polybar".source = ./config/polybar/run.sh;
            "bspwm/rc.d/theme".source = ./config/bspwmrc;
          })
          (mkIf (desktop.bspwm.enable) {
            "polybar" = {
              source = ./config/polybar;
              recursive = true;
            };
            "dunst/dunstrc".source = ./config/dunstrc;
          })
          # (mkIf cfg.shell.tmux.enable {
          #   "tmux/theme".source = ./config/tmux.conf;
          # })
        ];

        dataFile = mkMerge [
          (mkIf desktop.browsers.qutebrowser.enable {
            "qutebrowser/userstyles.css".source = let
              compiledStyles = with pkgs;
                runCommand "compileUserStyles" { buildInputs = [ sass ]; } ''
                  mkdir "$out"
                  for file in ${./userstyles/qutebrowser}/*.scss; do
                    scss --sourcemap=none \
                         --no-cache \
                         --style compressed \
                         --default-encoding utf-8 \
                         "$file" \
                         >>"$out/userstyles.css"
                  done
                '';
            in "${compiledStyles}/userstyles.css";
          })
        ];
      };
    })
  ]);
}
