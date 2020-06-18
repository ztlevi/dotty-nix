{ config, lib, pkgs, ... }: {
  my.packages = with pkgs; [
    calibre # managing my ebooks
    evince # pdf reader
    feh # image viewer
    mpv # video player
    xclip
    xdotool
    libqalculate # calculator cli w/ currency conversion
    (makeDesktopItem {
      name = "scratch-calc";
      desktopName = "Calculator";
      icon = "calc";
      exec = "scratch '${tmux}/bin/tmux new-session -s calc -n calc qalc'";
      categories = "Development";
    })
  ];

  ## Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  ## Fonts
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk
      font-awesome-ttf
    ];
    fontconfig.defaultFonts = {
      sansSerif = [ "DejaVu Sans" "Noto Sans CJK SC" "Noto Color Emoji" ];
      serif = [ "DejaVu Serif" "Noto Sans CJK SC" "Noto Color Emoji" ];
      monospace = [ "UbuntuMono Nerd Font Mono" "DejaVu Sans Mono" ];
    };
  };

  ## Apps/Services
  # For redshift
  location = (if config.time.timeZone == "America/Los_Angeles" then {
    latitude = 37.3382082;
    longitude = -121.8863286;
  } else if config.time.timeZone == "Europe/Copenhagen" then {
    latitude = 55.88;
    longitude = 12.5;
  } else
    { });

  services.xserver = {
    displayManager.lightdm.greeters.mini.user = config.my.username;
  };

  services.picom = {
    backend = "glx";
    vSync = true;
    opacityRules = [
      # "100:class_g = 'Firefox'"
      # "100:class_g = 'Vivaldi-stable'"
      "100:class_g = 'VirtualBox Machine'"
      # Art/image programs where we need fidelity
      "100:class_g = 'Gimp'"
      "100:class_g = 'Inkscape'"
      "100:class_g = 'aseprite'"
      "100:class_g = 'krita'"
      "100:class_g = 'feh'"
      "100:class_g = 'mpv'"
      "100:class_g = 'Rofi'"
      "100:class_g = 'Peek'"
      "99:_NET_WM_STATE@:32a = '_NET_WM_STATE_FULLSCREEN'"
    ];
    shadowExclude = [
      # Put shadows on notifications, the scratch popup and rofi only
      "name~='(scratch|Dunst)$'"
    ];
    settings.blur-background-exclude = [
      "window_type = 'dock'"
      "window_type = 'desktop'"
      "class_g = 'Rofi'"
      "_GTK_FRAME_EXTENTS@:c"
    ];
  };

  # Try really hard to get QT to respect my GTK theme.
  my.env.GTK_DATA_PREFIX = [ "${config.system.path}" ];
  my.env.QT_QPA_PLATFORMTHEME = "gtk2";
  qt5 = {
    style = "gtk2";
    platformTheme = "gtk2";
  };
  services.xserver.displayManager.sessionCommands = ''
    export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
    source "$XDG_CONFIG_HOME"/xsession/*.sh
    xrdb -merge "$XDG_CONFIG_HOME"/xtheme/*
  '';
}
