# Emacs is my main driver. I'm the author of Doom Emacs
# https://github.com/hlissner/doom-emacs. This module sets it up to meet my
# particular Doomy needs.

{ config, lib, pkgs, inputs, ... }:
with lib;
with lib.my;
let cfg = config.modules.editors.emacs;
in {
  options.modules.editors.emacs = {
    enable = mkBoolOpt false;
    doom = {
      enable = mkBoolOpt true;
      fromSSH = mkBoolOpt false;
    };

  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];
    user.packages = with pkgs; [
      unstable.emacs
      binutils
      # emacsPgtkGcc

      # If you use vterm, build emacs with vterm support
      # ((emacsPackagesNgGen emacs).emacsWithPackages (epkgs: [ epkgs.vterm ]))
      ## Doom dependencies
      librime
      git
      (ripgrep.override { withPCRE2 = true; })
      gnutls # for TLS connectivity

      ## Optional dependencies
      vmtouch # cache in memory
      fd # faster projectile indexing
      imagemagick # for image-dired
      (mkIf (config.programs.gnupg.agent.enable)
        pinentry_emacs) # in-emacs gnupg prompts
      zstd # for undo-fu-session/undo-tree compression

      ## Module dependencies
      # :checkers spell
      (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
      # :checkers grammar
      languagetool
      # :tools lookup & :lang org +roam
      sqlite
      # :lang cc
      ccls
      # :lang python
      nodePackages.pyright
      # :lang javascript
      nodePackages.typescript-language-server
      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-medium
      # :lang rust
      rustfmt
      unstable.rust-analyzer
    ];

    modules.shell.zsh.rcFiles = [ "${configDirBackup}/emacs/aliases.zsh" ];

    env.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];

    # init.doomEmacs = mkIf cfg.doom.enable ''
    #   if [ -d $HOME/.config/emacs ]; then
    #      ${
    #        optionalString cfg.doom.fromSSH ''
    #          git clone git@github.com:hlissner/doom-emacs.git $HOME/.config/emacs
    #          git clone git@github.com:hlissner/doom-emacs-private.git $HOME/.config/doom
    #        ''
    #      }
    #      ${
    #        optionalString (cfg.doom.fromSSH == false) ''
    #          git clone https://github.com/hlissner/doom-emacs $HOME/.config/emacs
    #          git clone https://github.com/ztlevi/doom-config $HOME/.config/doom
    #        ''
    #      }
    #   fi
    # '';

    # TODO:
    system.userActivationScripts.InstallDoomEmacs = ''
      if [[ ! -d ''${XDG_CONFIG_HOME}/doom ]]; then ${pkgs.git}/bin/git clone https://github.com/ztlevi/doom-config $XDG_CONFIG_HOME/doom; fi
      if [[ ! -d ''${XDG_CONFIG_HOME}/emacs ]];then
        ${pkgs.git}/bin/git clone https://github.com/hlissner/doom-emacs -b develop $XDG_CONFIG_HOME/emacs
        ''${XDG_CONFIG_HOME}/emacs/bin/doom install
      fi
    '';

    system.userActivationScripts.cacheEmacsInMemory = ''
      [[ -d ''${XDG_CONFIG_HOME}/doom ]] && ${pkgs.vmtouch}/bin/vmtouch -vt ''${XDG_CONFIG_HOME}/doom
      [[ -d ''${XDG_CONFIG_HOME}/emacs ]] && ${pkgs.vmtouch}/bin/vmtouch -vt ''${XDG_CONFIG_HOME}/emacs
      ${pkgs.libnotify}/bin/notify-send --urgency=low "Emacs config has been cached in memory!"
    '';

    fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];
  };
}
