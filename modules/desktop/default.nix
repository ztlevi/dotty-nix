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

    user.packages = with pkgs; [ xclip xdotool wmctrl emote ];

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
    system.userActivationScripts.updateDotty = ''
      [[ -d $DOTTY_ASSETS_HOME ]] && git -C $DOTTY_ASSETS_HOME pull || true
      [[ -d $DOTTY_HOME ]] && git -C $DOTTY_HOME pull || true
      [[ -d $DOTTY_CONFIG_HOME ]] && git -C $DOTTY_CONFIG_HOME pull || true
    '';

    system.userActivationScripts.copyFonts = ''
      if [[ -d "$DOTTY_ASSETS_HOME/fonts/general" ]]; then
        ${pkgs.fd}/bin/fd ".*\.(ttf|otf)" "$DOTTY_ASSETS_HOME/fonts/general" --print0 | \
        xargs -0 -n 1 -I{} ${pkgs.rsync}/bin/rsync -a --ignore-existing {} $HOME/.local/share/fonts/
      fi
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
