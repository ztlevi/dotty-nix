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
    # Fcitx configs need to be writable
    my.home.home.activation.downloadSougouDict = ''
      mkdir -p $XDG_CONFIG_HOME/fcitx/rime
      ln -s -f $DOTFILES/config/fcitx/config $XDG_CONFIG_HOME/fcitx/
      ln -s -f $DOTFILES/config/fcitx/profile $XDG_CONFIG_HOME/fcitx/
      ln -s -f $DOTFILES/config/fcitx/rime/default.custom.yaml $XDG_CONFIG_HOME/fcitx/rime/
      ln -s -f $DOTFILES/config/fcitx/rime/luna_pinyin.custom.yaml $XDG_CONFIG_HOME/fcitx/rime/

      # Download sougou pinyin dictionary
      if [[ ! -f $XDG_CONFIG_HOME/fcitx/rime/luna_pinyin.sogou.dict.yaml ]]; then
        ${pkgs.wget}/bin/wget https://github.com/vgist/rime-files/raw/master/luna_pinyin.sogou.dict.yaml -O $XDG_CONFIG_HOME/fcitx/rime/luna_pinyin.sogou.dict.yaml
      fi
    '';

  };
}
