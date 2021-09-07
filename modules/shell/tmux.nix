{ config, options, pkgs, lib, ... }:
with lib;
with lib.my;
let cfg = config.modules.shell.tmux;
in {
  options.modules.shell.tmux = with types; {
    enable = mkBoolOpt false;
    rcFiles = mkOpt (listOf (either str path)) [ ];
  };
  config = mkIf cfg.enable {
    user.packages = with pkgs; [ tmux xclip ];

    modules.shell.zsh.rcFiles =
      [ "${config.dotfiles.configDir}/shell/tmux/rc.zsh" ];
    modules.shell.zsh.envFiles =
      [ "${config.dotfiles.configDir}/shell/tmux/env.zsh" ];

    home.dataFile = {
      "tmux/plugins/tpm" = {
        source = pkgs.fetchFromGitHub {
          owner = "tmux-plugins";
          repo = "tpm";
          rev = "v3.0.0";
          sha256 = "18q5j92fzmxwg8g9mzgdi5klfzcz0z01gr8q2y9hi4h4n864r059";
        };
      };
    };

    home.configFile = {
      "tmux/tmux.conf".source =
        "${config.dotfiles.configDir}/shell/tmux/tmux.conf";
    };

    env.PATH = [ "${config.dotfiles.configDir}/shell/tmux/bin" ];
  };
}
