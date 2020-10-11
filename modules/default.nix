{ config, options, pkgs, lib, ... }:
with lib; {
  imports = [ ./desktop ./dev ./editors ./media ./services ./shell ./themes ];
}
