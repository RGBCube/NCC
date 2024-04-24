{ config, lib, ... }: with lib;

let
  inherit (config.networking) domain;

  sitePath = "/var/www/site";

  notFoundLocationConfig = {
    extraConfig                  = "error_page 404 /404.html;";
    locations."/404".extraConfig = "internal;";
  };
in systemConfiguration {
  services.nginx = enabled {
    appendHttpConfig = ''
      map $http_origin $allow_origin {
        ~^https://.+\.${domain}$ $http_origin;
      }

      map $http_origin $allow_methods {
        ~^https://.+\.${domain}$ "GET, HEAD, OPTIONS";
      }
    '';

    virtualHosts.${domain} = merge config.sslTemplate notFoundLocationConfig {
      root = sitePath;

      locations."/".tryFiles = "$uri $uri.html $uri/index.html =404";

      locations."/assets/".extraConfig = ''
        add_header Access-Control-Allow-Origin $allow_origin;
        add_header Access-Control-Allow-Methods $allow_methods;

        if ($request_method = OPTIONS) {
          add_header Content-Type text/plain;
          add_header Content-Length 0;
          return 204;
        }

        expires 24h;
      '';
    };

    virtualHosts."www.${domain}" = merge config.sslTemplate {
      locations."/".extraConfig = "return 301 https://${domain}$request_uri;";
    };

    virtualHosts._ = merge config.sslTemplate notFoundLocationConfig {
      root = sitePath;

      locations."/".extraConfig        = "return 404;";
      locations."/assets/".extraConfig = "return 301 https://${domain}$request_uri;";
    };
  };
}
