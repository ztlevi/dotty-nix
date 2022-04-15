{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.git;
in {
  options.modules.shell.git = {
    enable = mkBoolOpt false;
    # TODO: move gpg sign here
    enableGpgSign = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      delta
      git-lfs
      gitAndTools.gh
      (mkIf config.modules.shell.gnupg.enable gitAndTools.git-crypt)
    ];
    home.configFile = {
      "git" = {
        source = "${config.dotfiles.configDir}/shell/git/config/git";
        recursive = true;
      };
    };
    home.file = {
      ".ignore".source = "${config.dotfiles.configDir}/shell/git/.ignore";
    };
    modules.shell.zsh.rcFiles =
      [ "${config.dotfiles.configDir}/shell/git/rc.zsh" ];
    modules.shell.zsh.envFiles =
      [ "${config.dotfiles.configDir}/shell/git/env.zsh" ];
    env.PATH = [ "${config.dotfiles.configDir}/shell/git/bin" ];

    system.userActivationScripts.gitLocal = ''
      if [[ -f $DOTTY_ASSETS_HOME/git-local.sh ]]; then
        $DOTTY_ASSETS_HOME/git-local.sh
      fi
    '';

  };
}
