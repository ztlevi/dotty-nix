# modules/dev/node.nix --- https://nodejs.org/en/
#
# JS is one of those "when it's good, it's alright, when it's bad, it's a
# disaster" languages.

{ config, options, lib, pkgs, ... }:
with lib; {
  options.modules.dev.node = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.dev.node.enable {
    my = {
      packages = with pkgs; [ nodejs ];

      zsh = {
        env = lib.readFile <config/npm/env.zsh>;
        rc = lib.readFile <config/npm/aliases.zsh>;
      };

      home.xdg.configFile."npm/config".text = ''
        cache=$XDG_CACHE_HOME/npm
        prefix=$XDG_DATA_HOME/npm
      '';
    };
  };
}
