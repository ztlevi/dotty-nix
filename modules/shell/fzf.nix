{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.fzf;
in {
  options.modules.shell.fzf = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ fzf ];
    home.configFile = {
      "fzf" = {
        source = "${config.dotfiles.configDir}/shell/fzf";
        recursive = true;
      };
    };
    modules.shell.zsh.rcFiles =
      [ "${config.dotfiles.configDir}/shell/fzf/rc.zsh" ];
    modules.shell.zsh.envFiles =
      [ "${config.dotfiles.configDir}/shell/fzf/env.zsh" ];
  };
}
