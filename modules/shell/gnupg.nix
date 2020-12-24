{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.gnupg;
in {
  options.modules.shell.gnupg = with types; { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name}.services.gpg-agent = {
      enable = true;
      pinentryFlavor = "gnome3";
      defaultCacheTtl = 604800;
      maxCacheTtl = 604800;
    };

    user.packages = [ pkgs.tomb pkgs.gnupg ];
    modules.shell.zsh = {
      rcInit = ''
        export GPG_TTY="$(tty)"
        # Fallback to pinentry-curses if in ssh terminal
        if [[ -n "$SSH_CONNECTION" ]]; then
          export PINENTRY_USER_DATA="USER_CURSES=1"
        fi
      '';
    };

    system.userActivationScripts.changeGnupgPermission = ''
      mkdir -p ${homeDir}/.gnupg && chmod 700 ${homeDir}/.gnupg
      # Restart gpg-agent
      # ${pkgs.gnupg}/bin/gpgconf --kill gpg-agent
    '';
  };
}
