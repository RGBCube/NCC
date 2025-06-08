{ config, self, lib, ... }: let
  inherit (config.networking) domain;
  inherit (lib) enabled merge mkConst;

  fqdn = "shekels.${domain}";
  port = 8007;
in {
  imports = [
    (self + /modules/nginx.nix)
    (self + /modules/postgresql.nix)
  ];

  config.secrets.plausibleKey = {
    file  = ./key.age;
    owner = "plausible";
  };

  config.services.postgresql.ensure = [ "plausible" ];

  config.services.plausible = enabled {
    server = {
      disableRegistration = true; # Setting it explicitly just in case.

      secretKeybaseFile = config.secrets.plausibleKey.path;

      baseUrl = "https://${fqdn}";

      listenAddress = "::1";
      inherit port;
    };
  };

  options.services.plausible.extraNginxConfigFor = mkConst /* nginx */ (domain: ''
    proxy_set_header Accept-Encoding ""; # Substitution won't work if it is compressed.
    sub_filter "</head>" '<script defer data-domain="${domain}" src="https://${fqdn}/js/script.js"></script></head>';
    sub_filter_last_modified on;
    sub_filter_once on;
  '');

  config.services.nginx.virtualHosts.${fqdn} = merge config.services.nginx.sslTemplate {
    extraConfig = config.services.plausible.extraNginxConfigFor fqdn;

    locations."/" = {
      proxyPass       = "http://[::1]:${toString port}";
      proxyWebsockets = true;
    };
  };
}
