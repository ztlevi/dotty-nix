{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "fcitx5-pinyin-zhwiki";
  version = "0.2.3.20210823";
  src = fetchurl {
    url =
      "https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases/download/0.2.3/zhwiki-20210823.dict";
    sha256 = "1kys7nhnavvmaaw32rpyh10n1p892nyz5k2rx30fv44cbimb2mdk";
  };

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    install -D -m644 $src $out/share/fcitx5/pinyin/dictionaries/zhwiki.dict
  '';

  meta = with lib; {
    homepage = "https://github.com/felixonmars/fcitx5-pinyin-zhwiki";
    description = "Fcitx 5 Pinyin Dictionary from zh.wikipedia.org";
    license = licenses.unlicense;
  };
}
