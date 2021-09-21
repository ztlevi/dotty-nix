# When I'm stuck in the terminal or don't have access to Emacs, (neo)vim is my
# go-to. I am a vimmer at heart, after all.

{ config, options, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.editors.vim;
in {

  options.modules.editors.vim = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ neovim ];

    environment.shellAliases = {
      vim = "nvim";
      v = "nvim";
      sv = "sudo ${pkgs.neovim}/bin/nvim";
    };
    env.EDITOR = "nvim";
    env.VISUAL = "nvim";

    modules.shell.zsh.rcFiles =
      [ "${config.dotfiles.configDir}/editor/neovim/rc.zsh" ];
    home.file.".ideavimrc".source =
      "${config.dotfiles.configDir}/editor/neovim/.ideavimrc";
    home.configFile."nvim".source =
      "${config.dotfiles.configDir}/editor/neovim/config/nvim";
  };
}
