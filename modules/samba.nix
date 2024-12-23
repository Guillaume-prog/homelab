{ ... }: {

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        # Only allow home network and localhost access
        # "hosts allow" = "192.168.0.";
        # "hosts deny" = "0.0.0.0/0";

        # Disable guest accounts and force user login
        "security" = "user";
        "guest account" = "nobody";
        "map to guest" = "never";
      };

      media = {
        comment = "Media Files of the Black Library";
        path = "/srv/media";

        # User access
        "valid users" = "lexi";
        "guest ok" = "no";

        # File permissions
        browseable = "yes";
        "read only" = "no";

        "create mask" = "0755";
        "directory mask" = "0755";
      };
    };
  };

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

}