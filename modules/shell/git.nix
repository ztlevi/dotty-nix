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
      git-lfs
      gitAndTools.gh
      gitAndTools.diff-so-fancy
      (mkIf config.modules.shell.gnupg.enable gitAndTools.git-crypt)
    ];
    home.configFile = {
      "git/config".source = "${configDirBackup}/git/config";
      "git/ignore".source = "${configDirBackup}/git/ignore";
    };
    modules.shell.zsh.rcFiles = [ "${configDirBackup}/git/aliases.zsh" ];
  };
}
