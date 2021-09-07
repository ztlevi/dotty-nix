{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.docker;
in {
  options.modules.services.docker = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ docker docker-compose ];

    user.extraGroups = [ "docker" ];

    modules.shell.zsh.rcFiles =
      [ "${config.dotfiles.configDir}/misc/docker/rc.zsh" ];
    modules.shell.zsh.envFiles =
      [ "${config.dotfiles.configDir}/misc/docker/env.zsh" ];

    virtualisation = {
      docker = {
        enable = true;
        autoPrune.enable = true;
        enableOnBoot = false;
        # listenOptions = [];
      };
    };
  };
}
