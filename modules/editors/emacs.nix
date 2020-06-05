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
        ## Doom dependencies
        emacsUnstable
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
          ediff() { e --eval "(ediff-files \"$1\" \"$2\")"; }
        '';
        env = ''export PATH="$HOME/.emacs.d/bin:$PATH"'';
      };

    };
    system.userActivationScripts.InstallDoomEmacs = ''
      [ ! -d $HOME/.doom.d ] && ${pkgs.git}/bin/git clone https://github.com/ztlevi/doom-config ~/.doom.d
      if [ ! -d $HOME/.emacs.d ];then
        ${pkgs.git}/bin/git clone https://github.com/hlissner/doom-emacs -b develop ~/.emacs.d
        $HOME/.emacs.d/bin/doom install
      fi
    '';

    fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];
  };
}
