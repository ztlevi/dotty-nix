# Emacs is my main driver. I'm the author of Doom Emacs
# https://github.com/hlissner/doom-emacs. This module sets it up to meet my
# particular Doomy needs.

{ config, options, lib, pkgs, ... }:
with lib; {
  options.modules.editors.emacs = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.editors.emacs.enable {
    my = {
      packages = with pkgs; [
        unstable.emacs

        # If you use vterm, build emacs with vterm support
        # ((emacsPackagesNgGen emacs).emacsWithPackages (epkgs: [ epkgs.vterm ]))
        ## Doom dependencies
        librime
        git
        (ripgrep.override { withPCRE2 = true; })
        gnutls # for TLS connectivity

        ## Optional dependencies
        fd # faster projectile indexing
        imagemagick # for image-dired
        (lib.mkIf (config.programs.gnupg.agent.enable)
          pinentry_emacs) # in-emacs gnupg prompts
        zstd # for undo-fu-session/undo-tree compression

        ## Module dependencies
        # :checkers spell
        aspell
        aspellDicts.en
        aspellDicts.en-computers
        aspellDicts.en-science
        # :checkers grammar
        languagetool
        # :tools editorconfig
        editorconfig-core-c # per-project style config
        # :tools lookup & :lang org +roam
        sqlite
        # :lang cc
        # ccls
        # :lang javascript
        nodePackages.javascript-typescript-langserver
        # :lang latex & :lang org (latex previews)
        texlive.combined.scheme-medium
        # :lang rust
        rustfmt
        rls
      ];

      zsh = {
        rc = ''
          alias e='emacsclient -n'
          alias et="emacs -nw"
          alias ec="emacsclient"
          alias e.="emacsclient ."
          alias se="sudo -E emacs"
          alias doom='doom -y'
          alias magit="emacsclient -n -e \(magit-status\)"
          alias ke="pkill -SIGUSR2 -i emacs"
          alias edebug="emacs --debug-init"
          alias etime="emacs --timed-requires --profile"

          ediff() { e --eval "(ediff-files \"$1\" \"$2\")"; }
        '';
        env = ''export PATH="$HOME/.emacs.d/bin:$PATH"'';
      };

    };
    system.userActivationScripts.InstallDoomEmacs = ''
      if [ ! -d $HOME/.doom.d ]; then ${pkgs.git}/bin/git clone https://github.com/ztlevi/doom-config ~/.doom.d; fi
      if [ ! -d $HOME/.emacs.d ];then
        ${pkgs.git}/bin/git clone https://github.com/hlissner/doom-emacs -b develop ~/.emacs.d
        $HOME/.emacs.d/bin/doom install
      fi
    '';

    fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];
  };
}
