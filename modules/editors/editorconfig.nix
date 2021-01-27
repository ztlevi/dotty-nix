{ config, options, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.editors.editorconfig;
in {

  options.modules.editors.editorconfig = { enable = mkBoolOpt false; };

  config =
    mkIf cfg.enable { user.packages = with pkgs; [ editorconfig-core-c ]; };
}
