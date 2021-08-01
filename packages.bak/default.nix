[
  (self: super:
    with super; {
      my = {
        ant-dracula = (callPackage ./ant-dracula.nix { });
        linode-cli = (callPackage ./linode-cli.nix { });
        ripcord = (callPackage ./ripcord.nix { });
        zunit = (callPackage ./zunit.nix { });
        clairvoyance = (callPackage ./clairvoyance.nix {
          autoFocusPassword = true;
          enableHDPI = true;
          backgroundURL = "https://i.imgur.com/zt68gmt.jpeg";
        });
        flat-remix-gtk = (callPackage ./flat-remix-gtk.nix { });
      };

      nur = import (builtins.fetchTarball
        "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit super;
        };

      # Occasionally, "stable" packages are broken or incomplete, so access to the
      # bleeding edge is necessary, as a last resort.
      unstable = import <nixos-unstable> { inherit config; };
    })

  # emacsGit
  # (import (builtins.fetchTarball
  #   "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz"))
]
