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

    home.file.".SpaceVim.d".source = "${configDir}/vim/SpaceVim.d";
    home.file.".ideavimrc".source = "${configDir}/vim/ideavimrc";

    # Install spacevim
    system.userActivationScripts.InstallSpaceVim = ''
      if [ ! -d "$HOME/.SpaceVim" ]; then
        curl -sLf https://spacevim.org/install.sh | bash
      fi
    '';
  };
}
