{ inputs, lib, pkgs, ... }:

with lib;
with lib.my; {
  mkHost = path:
    attrs@{ system ? system, ... }:
    nixosSystem {
      inherit system;
      specialArgs = { inherit lib inputs; };
      modules = [
        {
          nixpkgs.pkgs = pkgs;
          networking.hostName =
            mkDefault (removeSuffix ".nix" (baseNameOf path));
        }
        (filterAttrs (n: v: !elem n [ "system" ]) attrs)
        ../.
        (import path)
      ];
    };

  mapHosts = dir:
    attrs@{ system ? system, ... }:
    mapModules dir (hostPath: mkHost hostPath attrs);
}
