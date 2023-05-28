# modules/dev/node.nix --- https://nodejs.org/en/
#
# JS is one of those "when it's good, it's alright, when it's bad, it's a
# disaster" languages.

{ config, options, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.dev.node;
in {
  options.modules.dev.node = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      nodejs
      yarn
      nodePackages.prettier
      nodePackages.typescript
      nodePackages.typescript-language-server
    ];

    env.PATH = [ "$(${pkgs.yarn}/bin/yarn global bin)" ];
    home.file = {
      ".eslintrc".source = "${config.dotfiles.configDir}/dev/node/.eslintrc";
      ".prettierrc".source =
        "${config.dotfiles.configDir}/misc/apps/.prettierrc";
    };

    # TODO: split cspell when it's available in nix package
    home.configFile = {
      "cspell" = { source = "${config.dotfiles.configDir}/misc/cspell"; };
    };

    modules.shell.zsh.rcFiles = [
      "${config.dotfiles.configDir}/dev/node/rc.zsh"
      "${config.dotfiles.configDir}/misc/cspell/rc.zsh"
    ];
    modules.shell.zsh.envFiles =
      [ "${config.dotfiles.configDir}/dev/node/env.zsh" ];
  };
}
