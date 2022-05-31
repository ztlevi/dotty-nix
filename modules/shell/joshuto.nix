{ config, options, pkgs, lib, ... }:
with lib;
with lib.my;
let cfg = config.modules.shell.joshuto;
in {
  options.modules.shell.joshuto = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ joshuto ];
    home.configFile."joshuto" = {
      source = "${config.dotfiles.configDir}/shell/joshuto/config/joshuto";
      recursive = true;
    };
    modules.shell.zsh.rcFiles =
      [ "${config.dotfiles.configDir}/shell/joshuto/rc.zsh" ];
  };
}
