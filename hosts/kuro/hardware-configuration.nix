# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ "${modulesPath}/installer/scan/not-detected.nix" ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "uas" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [
    # FIXME: Watch this thread for fix https://github.com/NixOS/nixpkgs/issues/101040
    # config.boot.kernelPackages.broadcom_sta
  ];
  # I have a different wifi card in my PC
  # use `sudo lshw -C network` and check driver attribute, it's kernel module.
  # To restart wifi module, `sudo modprobe -r iwlwifi && sudo modprobe iwlwifi`
  boot.blacklistedKernelModules = [
    # "iwlwifi"
    # "bcma-pci-bridge"
  ];
  modules.hardware = {
    audio.enable = true;
    fs = {
      enable = true;
      ssd.enable = true;
    };
    nvidia.enable = true;
  };

  environment.variables.WIRELESS_DEVICE = "wlo1";

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  nix.settings.max-jobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = true;

  # High-DPI console
  console.font =
    lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
}
