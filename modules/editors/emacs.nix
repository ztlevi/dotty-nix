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
    doom = { enable = mkBoolOpt true; };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];
    user.packages = with pkgs; [
      ## Emacs itself
      binutils       # native-comp needs 'as', provided by this
      # 29 + pgtk + native-comp
      ((emacsPackagesFor emacsPgtkGcc).emacsWithPackages (epkgs: [
        epkgs.vterm
      ]))

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
      clang-tools
      # :lang python
      nodePackages.pyright
      # :lang javascript
      nodePackages.typescript-language-server
      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-medium
      # :lang rust
      rustfmt
      unstable.rust-analyzer
      # :app everywhere
      xclip
      xdotool
      xorg.xprop
      xorg.xwininfo
    ];

    modules.shell.zsh.rcFiles =
      [ "${config.dotfiles.configDir}/editor/emacs/rc.zsh" ];

    env.PATH = [
      "$XDG_CONFIG_HOME/emacs/bin"
      "${config.dotfiles.configDir}/editor/emacs/bin"
    ];

    system.userActivationScripts.installDoomEmacs = ''
      if [[ $HOME != "/home/runner" ]]; then
        if [[ ! -d ''${XDG_CONFIG_HOME}/doom ]]; then
            ${pkgs.git}/bin/git clone https://github.com/ztlevi/doom-config $XDG_CONFIG_HOME/doom
        fi
        if [[ ! -d ''${XDG_CONFIG_HOME}/emacs ]];then
            ${pkgs.git}/bin/git clone https://github.com/hlissner/doom-emacs --depth 1 $XDG_CONFIG_HOME/emacs
            ''${XDG_CONFIG_HOME}/emacs/bin/doom install
        fi
      fi
    '';

    system.userActivationScripts.cacheEmacsInMemory = ''
      if [[ $HOME != "/home/runner" ]]; then
        [[ -d ''${XDG_CONFIG_HOME}/doom ]] && ${pkgs.vmtouch}/bin/vmtouch -t ''${XDG_CONFIG_HOME}/doom &>/dev/null
        [[ -d ''${XDG_CONFIG_HOME}/emacs ]] && ${pkgs.vmtouch}/bin/vmtouch -t ''${XDG_CONFIG_HOME}/emacs &>/dev/null
        ${pkgs.libnotify}/bin/notify-send --urgency=low "Emacs config has been cached in memory!"
      fi
    '';

    fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];
  };
}
