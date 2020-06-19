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
    my.home.home.activation.setupRimeConfig = ''
      mkdir -p $XDG_CONFIG_HOME/fcitx/rime
      ln -s -f $DOTFILES/config/fcitx/config $XDG_CONFIG_HOME/fcitx/
      ln -s -f $DOTFILES/config/fcitx/profile $XDG_CONFIG_HOME/fcitx/
      ln -s -f $DOTFILES/config/fcitx/rime/*.yaml $XDG_CONFIG_HOME/fcitx/rime/
      ln -s -f $DOTFILES/assets/rime-dictionaries/*.dict.yaml $XDG_CONFIG_HOME/fcitx/rime/

      # Download zhwiki pinyin dictionary
      if [[ ! -f $XDG_CONFIG_HOME/fcitx/rime/zhwiki.dict.yaml ]]; then
        ${pkgs.wget}/bin/wget --no-check-certificate https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases/download/0.2.1/zhwiki-20200601.dict.yaml \
          -O $XDG_CONFIG_HOME/fcitx/rime/zhwiki.dict.yaml
      fi
    '';

  };
}
