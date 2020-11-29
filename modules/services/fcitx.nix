{ config, options, pkgs, lib, ... }:
with lib;
with lib.my;
let cfg = config.modules.services.fcitx;
in {
  options.modules.services.fcitx = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    i18n.inputMethod.enabled = "fcitx";
    i18n.inputMethod.fcitx.engines = with pkgs.fcitx-engines; [ rime ];
    # Fcitx configs need to be writable
    # home.activation.setupRimeConfig = ''
    system.userActivationScripts.setupRimeConfig = ''
      mkdir -p $XDG_CONFIG_HOME/fcitx/rime
      ln -s -f $DOTFILES/config/fcitx/config $XDG_CONFIG_HOME/fcitx/
      ln -s -f $DOTFILES/config/fcitx/profile $XDG_CONFIG_HOME/fcitx/
      ln -s -f $DOTFILES/config/fcitx/rime/*.yaml $XDG_CONFIG_HOME/fcitx/rime/
      ln -s -f ${dotAssetDir}/rime-dictionaries/*.dict.yaml $XDG_CONFIG_HOME/fcitx/rime/

      # Download zhwiki pinyin dictionary
      if [[ ! -f $XDG_CONFIG_HOME/fcitx/rime/zhwiki.dict.yaml ]]; then
        [[ ! -f $WGETRC ]] && touch $WGETRC
        ${pkgs.wget}/bin/wget -c https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases/download/0.2.1/zhwiki-20200601.dict.yaml \
          -O $XDG_CONFIG_HOME/fcitx/rime/zhwiki.dict.yaml || echo "Download zhwiki failed"
      fi
    '';
  };
}
