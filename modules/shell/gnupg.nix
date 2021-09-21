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
      [ "${config.dotfiles.configDir}/misc/gpg/rc.zsh" ];

    system.userActivationScripts.gnupgInit = ''
      if [[ $HOME != "/home/runner" ]]; then
        [[ ! -f $HOME/.gnupg/pubring.kbx ]] && ${config.dotfiles.configDir}/misc/gpg/gpg_import.sh
      fi
    '';
  };
}
