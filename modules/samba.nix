{ ... }:
let
  data-folder = "/data";
in {

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
        path = data-folder;

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

  fileSystems.${data-folder} = {
    device = "/dev/disk/by-uuid/890d2a72-9b0a-49bd-93fe-69270e18373d";
    fsType = "ext4";
    options = [ "uid=1000" "gid=100" "dmask=002" "fmask=113" ]; # dmask = ug:rwx o:rx | fmask = ug:rw o:r
  };

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

}