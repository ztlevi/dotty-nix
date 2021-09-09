{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.woeusb;
in {
  options.modules.services.woeusb = { enable = mkBoolOpt false; };

  # Instructions to use woeusb: https://www.linuxbabe.com/ubuntu/easily-create-windows-10-bootable-usb-ubuntu
  # 1. lsblk
  # 2. sudo umount /dev/sdb1
  # 3. sudo woeusb -v --device path-to-windows-10.iso /dev/sdb
  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (writeScriptBin "woeusb" ''
        #!${stdenv.shell}
        TERM=xterm-256color ${woeusb}/bin/woeusb
      '')
      parted
    ];
  };
}
