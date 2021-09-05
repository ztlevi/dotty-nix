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
      python37
      # jetbrains.pycharm-professional
      pipenv
      python37Packages.pip
      python37Packages.grip
      python37Packages.ipython
      python37Packages.black
      python37Packages.setuptools
      python37Packages.gnureadline
      python37Packages.pylint
    ];

    modules.shell.zsh.rcFiles =
      [ "${config.dotfiles.configDirBackupDir}/python/aliases.zsh" ];
    modules.shell.zsh.envFiles =
      [ "${config.dotfiles.configDir}/dev/python/env.zsh" ];
  };
}
