{ ... }:
let
  config-dir = "/config";
in {

  # For sonarr installation
  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "dotnet-sdk-6.0.428"
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
      dataDir ="${config-dir}/radarr";
    };

    # Need to symlink dataDir
    bazarr = {
      enable = true;
      openFirewall = true;
    };

    # Need to symlink dataDir
    jellyseerr = {
      enable = true;
      openFirewall = true;
    };
  };

}