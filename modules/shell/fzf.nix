{ config, options, lib, pkgs, ... }:

with lib; {
  options.modules.shell.fzf = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.shell.fzf.enable {
    my = {
      packages = with pkgs; [ fzf ];
      home.xdg.configFile = {
        "fzf" = {
          source = <config/fzf>;
          recursive = true;
        };
      };
      zsh.rc = lib.readFile <config/fzf/aliases.zsh>;
      zsh.env = ''
        export FZF_BASE=${pkgs.fzf}/share/fzf
        ${lib.readFile <config/fzf/env.zsh>}
      '';
    };
  };
}
