{ config, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.desktop;
in {
  config = mkIf config.services.xserver.enable {
    assertions = [
      {
        assertion = (countAttrs (n: v: n == "enable" && value) cfg) < 2;
        message =
          "Can't have more than one desktop environment enabled at a time";
      }
      {
        assertion = let srv = config.services;
        in srv.xserver.enable || srv.sway.enable || !(anyAttrs
          (n: v: isAttrs v && anyAttrs (n: v: isAttrs v && v.enable)) cfg);
        message = "Can't enable a desktop app without a desktop environment";
      }
    ];

    user.packages = with pkgs; [
      xclip
      xdotool
      wmctrl
      libqalculate # calculator cli w/ currency conversion
      (makeDesktopItem {
        name = "scratch-calc";
        desktopName = "Calculator";
        icon = "calc";
        exec = ''scratch "${tmux}/bin/tmux new-session -s calc -n calc qalc"'';
        categories = "Development";
      })
    ];

    ## Sound
    sound.enable = true;
    hardware.pulseaudio.enable = true;

    ## Fonts
    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      fonts = with pkgs; [
        dejavu_fonts
        noto-fonts
        noto-fonts-cjk
        font-awesome-ttf
        (nerdfonts.override { fonts = [ "UbuntuMono" "FiraCode" ]; })
      ];
      fontconfig.defaultFonts = {
        sansSerif = [ "DejaVu Sans" "Noto Sans CJK SC" "Noto Color Emoji" ];
        serif = [ "DejaVu Serif" "Noto Sans CJK SC" "Noto Color Emoji" ];
        monospace = [ "UbuntuMono Nerd Font Mono" "DejaVu Sans Mono" ];
      };
    };

    system.userActivationScripts.copyFonts = with pkgs; ''
      ${fd}/bin/fd ".*\.(ttf|otf)" "$DOTTY_ASSETS_HOME/fonts/general" --print0 | \
      xargs -0 -n 1 -I{} rsync -a --ignore-existing {} $HOME/.local/share/fonts/
    '';

    # Clean up leftovers, as much as we can
    system.userActivationScripts.cleanupHome = ''
      pushd "${config.user.home}"
      rm -rf .compose-cache .nv .pki .dbus .fehbg
      rm -f .config/Trolltech.conf
      [ -s .xsession-errors ] || rm -f .xsession-errors*
      rm -f $XDG_CONFIG_HOME/mimeapps.list
      popd
    '';
  };
}
