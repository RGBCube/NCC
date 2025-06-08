{ config, self, lib, ... }: let
  inherit (config.networking) domain;
  inherit (lib) enabled merge;

  fqdn = "shekels.${domain}";
  port = 8007;
in {
  imports = [
    (self + /modules/nginx.nix)
    (self + /modules/postgresql.nix)
  ];

  secrets.plausibleKey = {
    file  = ./key.age;
    owner = "plausible";
  };

  services.postgresql.ensure = [ "plausible" ];

  services.plausible = enabled {
    server = {
      disableRegistration = true; # Setting it explicitly just in case.

      secretKeybaseFile = config.secrets.plausibleKey.path;

      baseUrl = "https://${fqdn}";

      listenAddress = "::1";
      inherit port;
    };
  };

  services.nginx.virtualHosts.${fqdn} = merge config.services.nginx.sslTemplate {
    locations."/" = {
      proxyPass       = "http://[::1]:${toString port}";
      proxyWebsockets = true;
    };
  };
}
