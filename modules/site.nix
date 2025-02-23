{ config, lib, ... }: let
  inherit (config.networking) domain;
  inherit (lib) enabled merge;

  pathSite = "/var/www/site";

  configNotFoundLocation = {
    extraConfig                  = "error_page 404 /404.html;";
    locations."/404".extraConfig = "internal;";
  };
in {
  services.nginx = enabled {
    virtualHosts.${domain} = merge config.nginx.sslTemplate configNotFoundLocation {
      root = pathSite;

      locations."/".tryFiles = "$uri $uri.html $uri/index.html =404";

      locations."/assets/".extraConfig = ''
        if ($request_method = OPTIONS) {
          ${config.nginx.headers}
          add_header Content-Type text/plain;
          add_header Content-Length 0;
          return 204;
        }

        expires 24h;
      '';
    };

    virtualHosts."www.${domain}" = merge config.nginx.sslTemplate {
      locations."/".extraConfig = "return 301 https://${domain}$request_uri;";
    };

    virtualHosts._ = merge config.nginx.sslTemplate configNotFoundLocation {
      root = pathSite;

      locations."/".extraConfig        = "return 404;";
      locations."/assets/".extraConfig = "return 301 https://${domain}$request_uri;";
    };
  };
}
