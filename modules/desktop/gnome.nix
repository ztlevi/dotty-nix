{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gnome;
in {
  options.modules.desktop.gnome = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      calibre # managing my ebooks
      mpv # video player
      celluloid # nice GTK GUI for mpv
      gnome.gnome-tweaks
      # Extensions
      gnomeExtensions.user-themes
      gnomeExtensions.dash-to-dock
      gnomeExtensions.clipboard-indicator
    ];

    home-manager.users.${config.user.name} = {
      xdg.mimeApps.enable = true;
      # Use get_window_class (xprop) to get the application class name
      # If not sure about the file type, right click and open with selected app, then check ~/.config/mimeapps.list
      xdg.mimeApps.defaultApplications = {
        "audio/mp3" = [ "io.github.celluloid_player.Celluloid.desktop" ];
        "audio/mp4" = [ "io.github.celluloid_player.Celluloid.desktop" ];
        "video/x-avi" = [ "io.github.celluloid_player.Celluloid.desktop" ];
        "video/x-matroska" = [ "io.github.celluloid_player.Celluloid.desktop" ];
        "video/mp4" =
          [ "io.github.celluloid_player.Celluloid.desktop" "mpv.desktop" ];
        "video/mpeg" = [ "io.github.celluloid_player.Celluloid.desktop" ];
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
        "application/x-gnome-saved-search" = [ "org.gnome.Nautilus.desktop" ];
        "image/jpeg" = [ "eog.desktop" ];
        "image/jpg" = [ "eog.desktop" ];
        "image/png" = [ "eog.desktop" ];
        "application/pdf" = [ "org.gnome.Evince.desktop" ];
        "text/x-python" = [ "emacs.desktop" ];
        "torrent" = [ "webtorrent" ];
      };
    };

    # link recursively so other modules can link files in their folders
    modules.shell.zsh.rcFiles =
      [ "${config.dotfiles.configDir}/wm/gnome/rc.zsh" ];

    console.useXkbConfig = true;
    services = {
      xserver = {
        enable = true;
        layout = "us";

        desktopManager.gnome.enable = true;
        displayManager.gdm.enable = true;
        displayManager.defaultSession = "gnome";
      };
    };
    system.userActivationScripts.loadDconfConfig = ''
      ${pkgs.dconf}/bin/dconf load /org/gnome/ <$DOTTY_CONFIG_HOME/wm/gnome/dconf/gnome.conf
    '';
  };
}
