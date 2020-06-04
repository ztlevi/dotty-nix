# modules/shell/zsh.nix --- ...

{ config, options, pkgs, lib, ... }:
with lib; {
  options.modules.shell.zsh = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.shell.zsh.enable {
    my = {
      packages = with pkgs; [
        zsh
        antigen
        htop
        starship
        tldr
        tree
        fasd
        fd
        direnv
        bashdb
        exa
        dust
        ripgrep
        shellcheck
        shfmt
        trash-cli
        neofetch
        mosh
        jq
      ];
      env.ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
      env.ZSH_CACHE_DIR = "$XDG_CACHE_HOME/zsh";

      alias.exa = "exa --group-directories-first";
      alias.l = "exa -1";
      alias.ll = "exa -lg";
      alias.la = "LC_COLLATE=C exa -la";
      alias.sc = "systemctl";
      alias.ssc = "sudo systemctl";

      # Write it recursively so other modules can write files to it
      home.xdg.configFile = {
        "zsh" = {
          source = <config/zsh>;
          recursive = true;
        };
        "starship.toml" = { source = <config/zsh/starship.toml>; };
      };
      zsh = {
        rc = ''
          _cache fasd --init posix-alias zsh-{hook,{c,w}comp{,-install}}
        '';
        env = ''
          export DOTFILES=$HOME/.dotfiles
        '';
      };
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      # I init completion myself, because enableGlobalCompInit initializes it too
      # soon, which means commands initialized later in my config won't get
      # completion, and running compinit twice is slow.
      enableGlobalCompInit = false;
      promptInit = "";

      interactiveShellInit = ''
        source ${pkgs.antigen}/share/antigen/antigen.zsh
      '';
    };

    system.userActivationScripts.cleanupInitCache = ''
      rm -rf $HOME/.cache/zsh
      rm -f $HOME/.config/zsh/*.zwc
      rm -f $HOME/.config/zsh/.zshrc.zwc
      rm -f $HOME/.config/zsh/.zshenv.zwc
    '';
  };
}
