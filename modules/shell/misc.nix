{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.misc;
in {
  options.modules.shell.misc = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ nodePackages.prettier ];
    home.file.".cspell.json".source = "${configDirBackup}/cspell/.cspell.json";
    home.file.".prettierrc".source = "${configDirBackup}/home/.prettierrc";
    home.file.".eslintrc".source = "${configDirBackup}/home/.eslintrc";
    home.file.".p4ignore".source = "${configDirBackup}/home/.p4ignore";
    home.file.".pylintrc".source = "${configDirBackup}/home/.pylintrc";
  };

}
