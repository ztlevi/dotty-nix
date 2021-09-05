{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.misc;
in {
  options.modules.shell.misc = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ nodePackages.prettier ];
    home.file.".cspell.json".source = "${config.dotfiles.configDirBackupDir}/cspell/.cspell.json";
    home.file.".prettierrc".source = "${config.dotfiles.configDirBackupDir}/home/.prettierrc";
    home.file.".eslintrc".source = "${config.dotfiles.configDirBackupDir}/home/.eslintrc";
    home.file.".p4ignore".source = "${config.dotfiles.configDirBackupDir}/home/.p4ignore";
    home.file.".pylintrc".source = "${config.dotfiles.configDirBackupDir}/home/.pylintrc";
  };

}
