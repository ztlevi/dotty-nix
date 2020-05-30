{ stdenv, fetchFromGitHub, gtk-engine-murrine }:

stdenv.mkDerivation {
  version = "1.0";
  name = "Flat-Remix-GTK";
  src = fetchFromGitHub {
    owner = "daniruiz";
    repo = "Flat-Remix-GTK";
    rev = "39fec3cb2da83a7959e2637365c1e61643bf9ae9";
    sha256 = "0rfv75w9yr8drc3x9g4iz2cb88ixy1lqbflvmb7farw4dz74fk5f";
    fetchSubmodules = true;
  };
  makeFlags = [ "PREFIX=$(out)" ];
  propagatedUserEnvPkgs = [ gtk-engine-murrine ];
}
