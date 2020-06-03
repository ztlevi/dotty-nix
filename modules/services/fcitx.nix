{ config, options, pkgs, lib, ... }:
with lib; {
  options.modules.services.fcitx = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.services.fcitx.enable {
    i18n.inputMethod.enabled = "fcitx";
    i18n.inputMethod.fcitx.engines = with pkgs.fcitx-engines; [ rime ];
    my = {
      home.xdg.configFile."fcitx" = {
        source = <config/fcitx>;
        recursive = true;
      };
      # home.home.file.".pam_environment".source = <config/fcitx/pam_environment>;
      home.home.activation.downloadSougouDict = ''
        # Download sougou pinyin dictionary
        if [[ ! -f $XDG_CONFIG_HOME/fcitx/rime/luna_pinyin.sogou.dict.yaml ]]; then
          ${pkgs.wget}/bin/wget https://github.com/vgist/rime-files/raw/master/luna_pinyin.sogou.dict.yaml -O $XDG_CONFIG_HOME/fcitx/rime/luna_pinyin.sogou.dict.yaml
        fi
      '';
    };

  };
}
