# themes/rainbow/default.nix --- a regal dracula-inspired theme

{ config, options, lib, pkgs, ... }:
with lib;
let cfg = config.modules;
in {
  options.modules.themes.rainbow = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.themes.rainbow.enable {
    modules.theme = {
      name = "rainbow";
      version = "0.0.1";
      path = ./.;

      wallpaper = {
        filter.options =
          "-gaussian-blur 0x2 -modulate 70 -level 5% -resize 3840x2160";
        # path = "/home/ztlevi/.dotfiles/assets/wallpapers/red-1.jpg";
      };
    };

    services.picom = {
      fade = true;
      fadeDelta = 5;
      fadeSteps = [ "0.04" "0.08" ];
      shadow = true;
      shadowOffsets = [ (-5) (-5) ];
      shadowOpacity = "0.36";
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

    fonts.fonts = [ pkgs.nerdfonts ];
    my.packages = with pkgs; [
      my.flat-remix-gtk
      capitaine-cursors
      flat-remix-icon-theme
      # my.ant-dracula
      # paper-icon-theme # for rofi
    ];
    # my.zsh.rc = lib.readFile ./zsh/prompt.zsh;

    my.home = {
      home.file = mkMerge [
        (mkIf cfg.desktop.browsers.firefox.enable {
          ".mozilla/firefox/${cfg.desktop.browsers.firefox.profileName}.default/chrome/userChrome.css" =
            {
              source = ./firefox/userChrome.css;
            };
        })
      ];

      xdg.configFile = mkMerge [
        (mkIf config.services.xserver.enable {
          "xtheme/90-theme".source = ./Xresources;
          # GTK
          "gtk-3.0/settings.ini".text = ''
            [Settings]
            gtk-theme-name=Flat-Remix-GTK
            gtk-icon-theme-name=Flat-Remix-Blue
            gtk-fallback-icon-theme=gnome
            gtk-application-prefer-dark-theme=false
            gtk-cursor-theme-name=capitaine-cursors-white
            gtk-cursor-theme-size=64
            gtk-xft-hinting=1
            gtk-xft-hintstyle=hintfull
            gtk-xft-rgba=none
          '';
          # GTK2 global theme (widget and icon theme)
          "gtk-2.0/gtkrc".text = ''
            gtk-theme-name="Flat-Remix-GTK"
            gtk-icon-theme-name="Flat-Remix-Blue"
            gtk-cursor-theme-name=capitaine-cursors-white
            gtk-cursor-theme-size=64
            gtk-font-name="Sans 10"
          '';
          # QT4/5 global theme
          "Trolltech.conf".text = ''
            [Qt]
            style=Flat-Remix-GTK
          '';
        })
        (mkIf cfg.desktop.bspwm.enable {
          "bspwm/rc.d/polybar".source = ./polybar/run.sh;
          "bspwm/rc.d/theme".source = ./bspwmrc;
        })
        (mkIf cfg.desktop.apps.rofi.enable {
          "rofi/theme" = {
            source = ./rofi;
            recursive = true;
          };
        })
        (mkIf (cfg.desktop.bspwm.enable) {
          "polybar" = {
            source = ./polybar;
            recursive = true;
          };
          "dunst/dunstrc".source = ./dunstrc;
        })
        (mkIf cfg.shell.tmux.enable { "tmux/theme".source = ./tmux.conf; })
      ];

      xdg.dataFile = mkMerge [
        (mkIf cfg.desktop.browsers.qutebrowser.enable {
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
  };
}
