# SDDM theme package
{ stdenv, fetchFromGitHub, autoFocusPassword ? false, backgroundURL ? null
, sha256 ? null, enableHDPI ? false, fileType ? "jpg" }:

let
  boolToStr = b: if b then "true" else "false";
  autoFocusPassword' = boolToStr autoFocusPassword;
  enableHDPI' = boolToStr enableHDPI;
  background = "Assets/Background." + fileType;
  themeConfig = builtins.toFile "theme.conf" ''
    [General]
    background=${background}
    autoFocusPassword=${autoFocusPassword'}
    enableHDPI=${enableHDPI'}
  '';

in stdenv.mkDerivation rec {
  name = "sddm-clairvoyance";
  src = fetchFromGitHub {
    owner = "eayus";
    repo = "sddm-theme-clairvoyance";
    rev = "dfc5984ff8f4a0049190da8c6173ba5667904487";
    sha256 = "13z78i6si799k3pdf2cvmplhv7n1wbpwlsp708nl6gmhdsj51i81";
  };

  installPhase = ''
    mkdir -p $out/share/sddm/themes/clairvoyance
    cp -r * $out/share/sddm/themes/clairvoyance
    cp ${themeConfig} $out/share/sddm/themes/clairvoyance/theme.conf
    ${if backgroundURL == null then
      ""
    else
      "cp ${
        builtins.fetchurl {
          url = backgroundURL;
          sha256 = sha256;
        }
      } $out/share/sddm/themes/clairvoyance/${background}"}
  '';

  meta = with stdenv.lib; {
    description = "eayus' sddm theme";
    homepage = "https://github.com/eayus/sddm-theme-clairvoyance";
    platforms = platforms.linux;
  };
}
