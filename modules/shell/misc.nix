{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.misc;
in {
  options.modules.shell.misc = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ nodePackages.prettier ];
    home.file.".cspell.json".source = "${configDir}/cspell/.cspell.json";
    home.file.".prettierrc".source = "${configDir}/home/.prettierrc";
    home.file.".eslintrc".source = "${configDir}/home/.eslintrc";
    home.file.".p4ignore".source = "${configDir}/home/.p4ignore";
    home.file.".pylintrc".source = "${configDir}/home/.pylintrc";
  };

}
