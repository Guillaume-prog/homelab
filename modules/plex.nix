{ ... }: {

  services.plex = {
    enable = true;
    openFirewall = true;
    dataDir = "/var/lib/plex"; # Needs changing in future
  };

}