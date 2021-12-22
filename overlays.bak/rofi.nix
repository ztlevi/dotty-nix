# rofi 1.6.1 cannot render svg, fallback to 1.5.4
self: super: rec {
  rofi-unwrapped = super.rofi-unwrapped.overrideAttrs (_: rec {
    version = "1.5.4";
    src = builtins.fetchTarball {
      url =
        "https://github.com/davatorium/rofi/releases/download/${version}/rofi-${version}.tar.gz";
      sha256 = "0k21g23sj01r0jd19nhd550wn4lmhyw2kmhdlbpcmky9f6imd1mw";
    };
  });
}
