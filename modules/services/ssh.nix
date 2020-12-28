  { options, config, lib, ... }:

  with lib;
  with lib.my;
  let cfg = config.modules.services.ssh;
  in {
    options.modules.services.ssh = { enable = mkBoolOpt false; };

    config = mkIf cfg.enable {
      services.openssh = {
        enable = true;
        # forwardX11 = true;
        # permitRootLogin = "no";
        challengeResponseAuthentication = false;
        passwordAuthentication = true;
        # Need this for GPG forwarding
        extraConfig = ''
          StreamLocalBindUnlink yes
        '';
      };

      user.openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCcK44geKeDenAUiie45J7SEYtTWZ7dj/RseitSz/uLiGjpFnrwc6fYcta9iya2SfNDLOfMx9gaT4pBFhytMuaWhxPPAmvrm6Q0OzhvheZCFj2vOSmbV+T0lt4Yama+N9Td9/u/n6mzeXhTZvg+GOOwghDv+ItgP7E/NXDEbJu+H0kS52T0GD3Do/j27qN7z6YxIZCNEF4cMvwMGuWKfDC4FoyCSndQoH+emU09YkRmEnPIWe9H1hG14OHUvpvHisdSk66O+l0w1OXCMQaz63mC/THUVgbgiji3IPqij5YArjZGOpcpEvZi5FgDPGy/u3MM5gv1xHai+HSXah+luf7qyvWg7uI9w3pka7SVpxTF6kGZTFNXcFYhsA1EsWJDS66LCbnx/bDUVQm6o1K0/lUpnSSbC+scRzqI5854z1fS46YW/0X3xnB/GoC8hN/hfm0AaQ46/cQ8N+nBnTBVotejGXJRI+/74q130GeQFjoP1VNfIGpOR9JMxw8U3e12flU= ztlevi@Tings-macbook.local"
      ];
    };
  }
