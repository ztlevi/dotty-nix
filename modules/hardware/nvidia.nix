{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.nvidia;
in {
  options.modules.hardware.nvidia = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    hardware.opengl.enable = true;

    services.xserver.videoDrivers = [ "nvidia" ];

    systemd.services.nvidia-control-devices = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart =
        "${pkgs.linuxPackages.nvidia_x11.bin}/bin/nvidia-smi";
    };

    environment.systemPackages = with pkgs; [
      # Install cuda https://nixos.wiki/wiki/Nvidia#CUDA
      git
      gitRepo
      gnupg
      autoconf
      curl
      procps
      gnumake
      utillinux
      m4
      gperf
      unzip
      cudatoolkit_11_1 # pytorch supports 11.1
      linuxPackages.nvidia_x11
      libGLU
      libGL
      xorg.libXi
      xorg.libXmu
      freeglut
      xorg.libXext
      xorg.libX11
      xorg.libXv
      xorg.libXrandr
      zlib
      ncurses5
      stdenv.cc
      binutils

      # Respect XDG conventions, damn it!
      (writeScriptBin "nvidia-settings" ''
        #!${stdenv.shell}
        mkdir -p "$XDG_CONFIG_HOME/nvidia"
        exec ${config.boot.kernelPackages.nvidia_x11.settings}/bin/nvidia-settings --config="$XDG_CONFIG_HOME/nvidia/settings"
      '')
    ];

    modules.shell.zsh.rcInit = ''
      export CUDA_PATH=${pkgs.cudatoolkit_11_1}
      export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.cudatoolkit_11_1.lib}/lib:${pkgs.cudatoolkit_11_1}/targets/x86_64-linux/lib:${pkgs.cudatoolkit_11_1}/extras/CUPTI/lib64:${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.ncurses5}/lib:$LD_LIBRARY_PATH
      export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib $EXTRA_LDFLAGS"
      export EXTRA_CCFLAGS="-I/usr/include $EXTRA_CCFLAGS"
    '';
  };
}
