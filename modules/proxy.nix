{ ... }: 
let
  config-dir = "/config/proxy";
in {

  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "lexi" ];
  virtualisation.oci-containers.backend = "docker";

  virtualisation.oci-containers.containers.proxy = {
    serviceName="proxy-npm";
    image = "jc21/nginx-proxy-manager:latest";

    ports = [
      "81:81" # Web portal
      "80:80" # HTTP
      "443:443" # HTTPS
    ];

    volumes = [
      "${config-dir}/data:/data"
      "${config-dir}/letsencrypt:/etc/letsencrypt"
    ];
  };

}