{ stdenv, lib, fetchgit }:

stdenv.mkDerivation rec {
  name = "fcitx5-material-color";
  version = "0.2.1";
  src = fetchgit {
    url = "https://github.com/hosxy/fcitx5-material-color";
    rev = "0.2.1";
    fetchSubmodules = false;
    deepClone = false;
    leaveDotGit = false;
    sha256 = "0drdypjf1njl7flkb5d581vchwlp4gaqyws3cp0v874wkwh4gllb";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    install -Dm644 arrow.png radio.png -t $out/share/${name}/
    for _variant in black blue brown deepPurple indigo orange pink red sakuraPink teal; do
      _variant_name=Material-Color-''${_variant^}
      mkdir -p $out/share/fcitx5/themes/$_variant_name/
      ln -s $out/share/${name}/arrow.png $out/share/fcitx5/themes/$_variant_name/arrow.png
      ln -s $out/share/${name}/radio.png $out/share/fcitx5/themes/$_variant_name/radio.png
      install -Dm644 theme-$_variant.conf $out/share/fcitx5/themes/$_variant_name/theme.conf
      sed -i "s/^Name=.*/Name=$_variant_name/" $out/share/fcitx5/themes/$_variant_name/theme.conf
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/hosxy/Fcitx5-Material-Color";
    description = "Material color theme for fcitx5";
    license = licenses.asl20;
  };
}
