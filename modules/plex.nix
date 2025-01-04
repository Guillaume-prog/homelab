{ ... }: {

  services.plex = {
    enable = true;
    openFirewall = true;
    dataDir = "/config/plex"; # Needs changing in future
  };

}