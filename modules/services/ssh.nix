{ config, pkgs, ... }:

{ config, options, pkgs, lib, ... }:
with lib; {
  options.modules.services.ssh = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.services.ssh.enable {
    services.openssh = {
      enable = true;
      forwardX11 = true;
      permitRootLogin = "no";
      passwordAuthentication = false;

      # Allow local LAN to connect with passwords
      extraConfig = ''
        Match address 192.168.0.0/24
        PasswordAuthentication yes
      '';
    };

    my.user.openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDCnX7bBB/qLYetFyExpHL+IiuGw/VMXBVc4kNqabn9MDcAKGdklRmZKno8z7ADj1pZY3AfNv25jd4RQsxi2Moj0Pc4e0aESG3u4BlDt3vSOUscx1icrAFedpu2CELewZk92KxJtYZnmqDp27o2FrEo9f0o21Tstzy12dOE86uUVIqFMkBDGrJxcEDV1I5LTfbG1LKmeQNv+Gn5E197TYzgW6VIaYCwSoVWqc7C7h1/djVE7i/lnkHXdneZEiPqb+oXuU5Nxv8tVL+7QWfPtST54RxT1CvPRL9pBgShprDs74EJTEaulwCn0kn4fIsy20HGk2Wn5BTsRFoKvKbu77twa4NfGs6qYKLe3vFuXYtJIyPITTT0ClpHXoQ2yu+cbDlezVZkwnhnCNEo3HZHpYE/VJIgg5DznXEd8X1mbzA75fHrQaQG7BkuwzhgBRhA6JagW1A54Fy+ZDOINxRTaTLYVXRph6DPLB6wwkHu3Pn28i3FhkX3LVz9OoabqtSJI8= ztlevi.work@.gmail.com"
    ];
  };
}
