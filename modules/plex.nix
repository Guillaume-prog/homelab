{ ... }:
let
  config-dir = "/config";
in {

  # For sonarr installation
  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-wrapped-6.0.36"
  ];

  services = {
    plex = {
      enable = true;
      openFirewall = true;
      dataDir = "${config-dir}/plex";
    };

    sonarr = {
      enable = true;
      openFirewall = true;
      group = "plex";
      dataDir="${config-dir}/sonarr";
    };
    
    radarr = {
      enable = true;
      openFirewall = true;
      group = "plex";
      dataDir="${config-dir}/radarr";
    };
  };

}