# modules/dev/python.nix --- https://godotengine.org/
#
# Python's ecosystem repulses me. The list of environment "managers" exhausts
# me. The Py2->3 transition make trainwrecks jealous. But SciPy, NumPy, iPython
# and Jupyter can have my babies. Every single one.

{ config, options, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.dev.python;
in {
  options.modules.dev.python = { enable = mkBoolOpt false; };

  config = mkIf config.modules.dev.python.enable {
    user.packages = with pkgs; [
      python38
      # You can install multiple python versions, the first one installed will be mapped as global python3
      # python39
      # jetbrains.pycharm-professional
      python38Packages.pip
      python38Packages.grip
      python38Packages.ipython
      python38Packages.black
      python38Packages.setuptools
      python38Packages.gnureadline
      python38Packages.pylint
      python38Packages.poetry
    ];

    modules.shell.zsh.rcFiles =
      [ "${config.dotfiles.configDir}/dev/python/rc.zsh" ];
    modules.shell.zsh.envFiles =
      [ "${config.dotfiles.configDir}/dev/python/env.zsh" ];
    home.file = {
      ".pylintrc".source = "${config.dotfiles.configDir}/dev/python/.pylintrc";
      ".mypy.ini".source = "${config.dotfiles.configDir}/dev/python/.mypy.ini";
      ".condarc".source = "${config.dotfiles.configDir}/dev/python/.condarc";
    };
    home.configFile = {
      "pudb" = {
        source = "${config.dotfiles.configDir}/dev/python/config/pudb";
        recursive = true;
      };
      "flake8".source = "${config.dotfiles.configDir}/dev/python/config/flake8";
    };
  };
}
