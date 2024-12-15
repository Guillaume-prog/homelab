{ ... }: 
let
  server-name = "black-library";
in {

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        # "workgroup" = "ELDAR";
        "server string" = server-name;
        "netbios name" = server-name;

        # Only allow home network and localhost access
        "hosts allow" = "192.168.0. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";

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
        browseable = "yes";
        "read only" = "no";

        # File permissions
        "create mask" = "0755";
        "directory mask" = "0755";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

}