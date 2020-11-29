{ config, options, pkgs, lib, ... }:
with lib;
with lib.my;
let cfg = config.modules.shell.ranger;
in {
  options.modules.shell.ranger = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      ranger
      # For image previews
      (lib.mkIf config.services.xserver.enable w3m)
    ];
    home.configFile."ranger" = {
      source = "${configDir}/ranger";
      recursive = true;
    };
    modules.shell.zsh.rcFiles = [ "${configDir}/ranger/aliases.zsh" ];
  };
}
