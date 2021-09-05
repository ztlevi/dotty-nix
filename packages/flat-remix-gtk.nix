{ lib, stdenv, fetchurl, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "flat-remix-gtk";
  version = "20201106";

  src = fetchurl {
    url =
      "https://github.com/daniruiz/flat-remix-gtk/archive/${version}.tar.gz";
    sha256 = "1z16i09pchs5a4sw9rvh169kjigbzw1sk8b65fdsrlpp57iwic3r";
  };
  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a ./Flat-Remix-GTK-Blue $out/share/themes
    runHook postInstall
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";

  meta = with lib; {
    description =
      "Flat Remix is a GTK application theme inspired by material design.";
    homepage = "https://github.com/daniruiz/flat-remix-gtk";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.pbogdan ];
  };
}
