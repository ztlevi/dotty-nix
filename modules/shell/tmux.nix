{ config, options, pkgs, lib, ... }:
with lib;

{
  options.modules.shell.tmux = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf config.modules.shell.tmux.enable {
    my = {
      packages = with pkgs;
        [
          # The developer of tmux chooses not to add XDG support for religious
          # reasons (see tmux/tmux#142). Fortunately, nix makes this easy:
          (writeScriptBin "tmux" ''
            #!${stdenv.shell}
            exec ${tmux}/bin/tmux -f "$TMUX_HOME/config" "$@"
          '')
        ];

      env.TMUX_HOME = "$XDG_CONFIG_HOME/tmux";
      env.TMUX_PLUGIN_MANAGER_PATH = "$XDG_DATA_HOME/tmux/plugins";
      env.TMUXIFIER = "$XDG_DATA_HOME/tmuxifier";
      env.TMUXIFIER_LAYOUT_PATH = "$XDG_DATA_HOME/tmuxifier";
      env.PATH = [ "$XDG_DATA_HOME/tmuxifier/bin" "$XDG_CONFIG_HOME/tmux/bin" ];

      zsh.rc = ''
        _cache tmuxifier init -
        ${lib.readFile <config/tmux/aliases.zsh>}
      '';

      home.xdg.dataFile = {
        "tmux/plugins/tpm" = {
          source = pkgs.fetchFromGitHub {
            owner = "tmux-plugins";
            repo = "tpm";
            rev = "v3.0.0";
            sha256 = "18q5j92fzmxwg8g9mzgdi5klfzcz0z01gr8q2y9hi4h4n864r059";
          };
        };
        "tmuxifier" = {
          source = pkgs.fetchFromGitHub {
            owner = "jimeh";
            repo = "tmuxifier";
            rev = "v0.13.0";
            sha256 = "1b6a1cw2mnml84k5vhbcp58kvp94xlnlpp4kwdhqw4jrzfgcjfzd";
          };
        };
      };

      home.xdg.configFile = {
        "tmux" = {
          source = <config/tmux>;
          recursive = true;
        };
      };
    };
  };
}
