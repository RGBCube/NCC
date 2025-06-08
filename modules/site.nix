{ self, config, lib, ... }: let
  inherit (config.networking) domain;
  inherit (lib) enabled merge;

  fqdn = domain;
  root = "/var/www/site";
in {
  imports = [(self + /modules/nginx.nix)];

  services.nginx = enabled {
    appendHttpConfig = /* nginx */ ''
      # Cache only successful responses.
      map $status $cache_header {
        200     "public";
        302     "public";
        default "no-cache";
      }
    '';

    virtualHosts.${fqdn} = merge config.services.nginx.sslTemplate {
      inherit root;

      locations."/".tryFiles = "$uri $uri.html $uri/index.html =404";

      locations."~ ^/assets/(fonts|icons|images)/".extraConfig = /* nginx */ ''
        expires max;
        ${config.services.nginx.headers}
        add_header Cache-Control $cache_header always;
      '';

      extraConfig = /* nginx */ ''
        error_page 404 /404.html;

        ${config.services.plausible.extraNginxConfigFor fqdn}
      '';

      locations."/404".extraConfig = /* nginx */ ''
        internal;
      '';
    };

    virtualHosts."www.${fqdn}" = merge config.services.nginx.sslTemplate {
      locations."/".return = "301 https://${fqdn}$request_uri";
    };

    virtualHosts._ = merge config.services.nginx.sslTemplate {
      locations."/".return = "301 https://${fqdn}/404";
    };
  };
}
