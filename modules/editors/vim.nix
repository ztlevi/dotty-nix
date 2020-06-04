# When I'm stuck in the terminal or don't have access to Emacs, (neo)vim is my
# go-to. I am a vimmer at heart, after all.

{ config, options, lib, pkgs, ... }:
with lib; {
  options.modules.editors.vim = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.editors.vim.enable {
    my = {
      packages = with pkgs; [ editorconfig-core-c neovim vimPlugins.spacevim ];

      alias.vim = "nvim";
      alias.v = "nvim";
      alias.sv = "sudo ${pkgs.neovim}/bin/nvim";
      env.EDITOR = "nvim";
      env.VISUAL = "nvim";

      home.home.file.".SpaceVim.d".source = <config/vim/SpaceVim.d>;
      home.home.file.".ideavimrc".source = <config/vim/ideavimrc>;

      # Install spacevim
      zsh.rc = ''
        if [ ! -d "$HOME/.SpaceVim" ]; then
          curl -sLf https://spacevim.org/install.sh | bash
        fi
      '';
    };

  };
}
