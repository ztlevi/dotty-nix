# Kuro -- my desktop

{ ... }: {
  imports = [ ../home.nix ./hardware-configuration.nix ];

  modules = {
    theme.active = "flat-remix";
    desktop = {
      # bspwm.enable = true;
      gnome.enable = true;
      wayland.enable = false;

      apps = {
        obsidian.enable = true;
        # rofi.enable = true;
        # etcher.enable = true;
        # woeusb.enable = true;
        # webtorrent.enable = true;
      };

      # vm.virtualbox.enable = true;

      term.default = "alacritty";
      # term.st.enable = true;
      term.alacritty.enable = true;

      browsers.default = "microsoft-edge";
      browsers.edge.enable = true;
      # browsers.chrome.enable = true;
      # browsers.firefox.enable = true;
      # browsers.qutebrowser.enable = true;
      # browsers.vimb.enable = true;

      # gaming.emulators.psx.enable = true;
      # gaming.steam.enable = true;
      media = {
        mpv.enable = true;
        downloader.enable = true;
        # spotify.enable = true;
        graphics.tools.enable = true; # raster/vector/sprites
        recording.video.enable = true; # recording screen/audio
        docs.pdf.enable = true;
        # docs.libreoffice.enable = true;
        chat.telegram.enable = true;
        chat.discord.enable = true;
        # chat.skype.enable = true;
        chat.zoom.enable = true;
      };
    };

    editors = {
      default = "nvim";
      emacs.enable = true;
      vim.enable = true;
      vscode.enable = true;
      editorconfig.enable = true;
    };

    dev = {
      cc.enable = true;
      # common-lisp.enable = true;
      rust.enable = true;
      node.enable = true;
      python.enable = true;
      # lua.enable = true;
      # lua.love2d.enable = true;
    };

    shell = {
      direnv.enable = true;
      git.enable = true;
      # gnupg.enable = true;
      # weechat.enable = true;
      fzf.enable = true;
      # sk.enable = true;
      pass.enable = true;
      tmux.enable = true;
      # ranger.enable = true;
      joshuto.enable = true;
      zsh.enable = true;
    };

    services = {
      # syncthing.enable = true;
      docker.enable = true;
      fcitx.enable = true;
      ssh.enable = true;
    };
  };

  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  networking.networkmanager.enable = true;
  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so this
  # generated config replicates the default behaviour.
  networking.useDHCP = false;
}
