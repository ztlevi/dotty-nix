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
      enableExtraSocket = true; # For GPG forwarding
    };

    user.packages = [ pkgs.tomb pkgs.gnupg ];
    modules.shell.zsh.rcFiles =
      [ "${config.dotfiles.configDirBackupDir}/gpg/aliases.zsh" ];

    system.userActivationScripts.gnupgInit = ''
      if [[ $HOME != "/home/runner" ]]; then
        [[ ! -f $HOME/.gnupg/pubring.kbx ]] && $DOTTY_CONFIG_HOME/misc/gpg/gpg_import.sh

        # https://github.com/microsoft/Git-Credential-Manager-Core/blob/main/docs/linuxcredstores.md
        if [[ ! -f $HOME/.local/share/password-store/.gpg-id ]]; then
            if (git config --get user.email) >/dev/null; then
            pass init $(git config --get user.email)
            else
            echo-fail "Please config git email first\!"
            fi
        fi
      fi
    '';
  };
}
