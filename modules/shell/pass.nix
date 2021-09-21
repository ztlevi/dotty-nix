{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.pass;
in {
  options.modules.shell.pass = with types; {
    enable = mkBoolOpt false;
    passwordStoreDir = mkOpt str "$HOME/.secrets/password-store";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs;
      [
        (pass.withExtensions (exts:
          [ exts.pass-otp exts.pass-genphrase ]
          ++ (if config.modules.shell.gnupg.enable then
            [ exts.pass-tomb ]
          else
            [ ])))
      ];
    env.PASSWORD_STORE_DIR = cfg.passwordStoreDir;

    system.userActivationScripts.passInit = ''
      # https://github.com/microsoft/Git-Credential-Manager-Core/blob/main/docs/linuxcredstores.md
      if [[ $HOME != "/home/runner" ]]; then
        if (${pkgs.git}/bin/git config --get user.email) >/dev/null; then
          if [[ ! -f $HOME/.local/share/password-store/.gpg-id ]]; then
            ${pkgs.pass}/bin/pass init $(${pkgs.git}/bin/git config --get user.email)
          fi
        else
          ${pkgs.coreutils}/bin/echo "Please config git email first\!"
        fi
      fi
    '';
  };
}
