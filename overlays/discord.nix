self: super: rec {
  discord = super.discord.overrideAttrs (_: rec {
    version = "0.0.13";
    src = builtins.fetchTarball {
      url =
        "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "0jps9dqjvzr2kg2xxcl0s3vmkpcnqnfa8m76r0n0prk239hpc63m";
    };
  });
}
