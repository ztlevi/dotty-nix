# Kuro -- my desktop

{ pkgs, options, config, ... }: {
  imports = [
    ../personal.nix # common settings
    ./hardware-configuration.nix
  ];

  modules = {
    desktop = {
      bspwm.enable = true;

      apps.rofi.enable = true;
      apps.discord.enable = true;
      # apps.skype.enable = true;
      apps.daw.enable = true; # making music
      apps.graphics.enable = true; # raster/vector/sprites
      apps.recording.enable = true; # recording screen/audio
      apps.vm.enable = true; # virtualbox for testing

      term.default = "alacritty";
      # term.st.enable = true;
      term.alacritty.enable = true;

      browsers.default = "google-chrome-stable";
      browsers.chrome.enable = true;
      # browsers.firefox.enable = true;
      # browsers.qutebrowser.enable = true;
      # browsers.vimb.enable = true;

      # gaming.emulators.psx.enable = true;
      # gaming.steam.enable = true;
    };

    editors = {
      default = "nvim";
      emacs.enable = true;
      vim.enable = true;
    };

    dev = {
      cc.enable = true;
      common-lisp.enable = true;
      rust.enable = true;
      node.enable = true;
      python.enable = true;
      # lua.enable = true;
      # lua.love2d.enable = true;
    };

    media = {
      mpv.enable = true;
      spotify.enable = true;
    };

    shell = {
      direnv.enable = true;
      git.enable = true;
      gnupg.enable = true;
      # weechat.enable = true;
      fzf.enable = true;
      pass.enable = true;
      tmux.enable = true;
      ranger.enable = true;
      zsh.enable = true;
    };

    services = {
      # syncthing.enable = true;
      docker.enable = true;
      fcitx.enable = true;
    };

    # themes.aquanaut.enable = true;
    themes.rainbow.enable = true;
  };

  programs.ssh.startAgent = true;
  networking.networkmanager.enable = true;
  time.timeZone = "America/Los_Angeles";
}
