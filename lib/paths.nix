{ self, lib, ... }:

with builtins;
with lib; rec {
  # ...
  dotFilesDir = toString ../.;
  modulesDir = "${dotFilesDir}/modules";
  configDirBackup = "${dotFilesDir}/config-backup";
  configDir = "${dotFilesDir}/config";
  binDir = "${dotFilesDir}/bin";
  dotAssetDir = "$XDG_CONFIG_HOME/dotfiles/assets";
  themesDir = "${modulesDir}/themes";
  homeDir = "/home/${
      let name = getEnv "USERNAME";
      in if elem name [ "" "root" ] then "ztlevi" else name
    }";
}
