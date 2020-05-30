{ config, options, pkgs, lib, ... }:
with lib; {
  options.modules.shell.ranger = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.shell.ranger.enable {
    my = {
      packages = with pkgs; [
        ranger
        # For image previews
        (lib.mkIf config.services.xserver.enable w3m)
      ];
      home.xdg.configFile."ranger" = {
        source = <config/ranger>;
        recursive = true;
      };
      zsh.rc = lib.readFile <config/ranger/aliases.zsh>;
    };
  };
}
