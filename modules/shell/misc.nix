{ config, options, lib, pkgs, ... }:

with lib; {
  options.modules.shell.misc = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.shell.misc.enable {
    my = {
      packages = with pkgs; [ nodePackages.prettier ];
      home.home.file.".cspell.json".source = <config/cspell/.cspell.json>;
      home.home.file.".prettierrc".source = <config/home/.prettierrc>;
      home.home.file.".eslintrc".source = <config/home/.eslintrc>;
      home.home.file.".p4ignore".source = <config/home/.p4ignore>;
      home.home.file.".pylintrc".source = <config/home/.pylintrc>;
    };
  };

}
