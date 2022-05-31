{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.nvidia;
in {
  # https://nixos.wiki/wiki/Nvidia#CUDA
  options.modules.hardware.nvidia = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.opengl.enable = true;
    hardware.nvidia.modesetting.enable = config.modules.desktop.wayland.enable;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
