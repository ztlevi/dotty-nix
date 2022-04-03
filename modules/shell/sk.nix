{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.sk;
in {
  options.modules.shell.sk = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ skim ];
    modules.shell.zsh.rcFiles = [
      "${pkgs.skim}/share/skim/key-bindings.zsh"
      "${pkgs.skim}/share/skim/completion.zsh"
      "${config.dotfiles.configDir}/shell/sk/rc.zsh"
    ];
    modules.shell.zsh.envFiles =
      [ "${config.dotfiles.configDir}/shell/sk/env.zsh" ];
  };
}
