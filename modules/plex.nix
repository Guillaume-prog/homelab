
{ pkgs, lib, ... }:
let
  uid = "1000";
  gid = "100";
  tz = "Etc/UTC";

  config-dir = "/config";
  data-dir = "/data";

  lan-network = "192.168.1.0/24";

  systemd-conf = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-plex-config_default.service"
    ];
    requires = [
      "docker-network-plex-config_default.service"
    ];
    partOf = [
      "docker-compose-plex-config-root.target"
    ];
    wantedBy = [
      "docker-compose-plex-config-root.target"
    ];
  };

in {
  # Runtime
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  services.plex = {
    enable = true;
    openFirewall = true;
    dataDir = "${config-dir}/plex";
  };

  # QBitTorrent
  virtualisation.oci-containers.containers."qbittorrent" = {
    image = "dyonr/qbittorrentvpn";
    environment = {
      "PGID" = gid;
      "PUID" = uid;
      "LAN_NETWORK" = lan-network;
      "NAME_SERVERS" = "1.1.1.1,1.0.0.1";
      "HEALTH_CHECK_HOST" = "one.one.one.one";
      "VPN_ENABLED" = "yes";
      "VPN_TYPE" = "openvpn";
      "ENABLE_SSL" = "no";
    };
    volumes = [
      "${data-dir}/downloads:/downloads:rw"
      "${config-dir}/qbittorrent:/config:rw"
    ];
    ports = [
      "8080:8080/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=qbittorrent"
      "--network=plex-config_default"
      "--privileged"
    ];
  };

  # Radarr
  virtualisation.oci-containers.containers."radarr" = {
    image = "lscr.io/linuxserver/radarr:latest";
    environment = {
      "PGID" = gid;
      "PUID" = uid;
      "TZ" = tz;
    };
    volumes = [
      "${data-dir}/downloads:/downloads:rw"
      "${data-dir}/movies:/movies:rw"
      "${config-dir}/radarr:/config:rw"
    ];
    ports = [
      "7878:7878/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=radarr"
      "--network=plex-config_default"
    ];
  };

  # Sonarr
  virtualisation.oci-containers.containers."sonarr" = {
    image = "lscr.io/linuxserver/sonarr:latest";
    environment = {
      "PGID" = gid;
      "PUID" = uid;
      "TZ" = tz;
    };
    volumes = [
      "${data-dir}/downloads:/downloads:rw"
      "${data-dir}/tv:/tv:rw"
      "${config-dir}/sonarr:/config:rw"
    ];
    ports = [
      "8989:8989/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=sonarr"
      "--network=plex-config_default"
    ];
  };

  # Prowlarr
  virtualisation.oci-containers.containers."prowlarr" = {
    image = "lscr.io/linuxserver/prowlarr:latest";
    environment = {
      "PGID" = gid;
      "PUID" = uid;
      "TZ" = tz;
    };
    volumes = [
      "${data-dir}/prowlarr:/config:rw"
    ];
    ports = [
      "9696:9696/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=prowlarr"
      "--network=plex-config_default"
    ];
  };

  # Overseerr
  virtualisation.oci-containers.containers."overseerr" = {
    image = "lscr.io/linuxserver/overseerr:latest";
    environment = {
      "PGID" = gid;
      "PUID" = uid;
      "TZ" = tz;
    };
    volumes = [
      "${config-dir}/overseerr:/config:rw"
    ];
    ports = [
      "5055:5055/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=overseerr"
      "--network=plex-config_default"
    ];
  };

  # Systemd stuff
  systemd.services."docker-qbittorrent" = systemd-conf;
  systemd.services."docker-radarr" = systemd-conf;
  systemd.services."docker-sonarr" = systemd-conf;
  systemd.services."docker-prowlarr" = systemd-conf;
  systemd.services."docker-overseerr" = systemd-conf;

  # Firewall
  networking.firewall.allowedTCPPorts = [ 5055 7878 8080 8989 9696 ];

  # Networks
  systemd.services."docker-network-plex-config_default" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f plex-config_default";
    };
    script = ''
      docker network inspect plex-config_default || docker network create plex-config_default
    '';
    partOf = [ "docker-compose-plex-config-root.target" ];
    wantedBy = [ "docker-compose-plex-config-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-plex-config-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
