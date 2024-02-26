{ config, ulib, ... }: with ulib;

let
  inherit (config.networking) domain;

  path = "/var/www/site";

  notFoundLocationConfig = {
    extraConfig                         = "error_page 404 /404.html;";
    locations."= /404.html".extraConfig = "internal;";
  };
in serverSystemConfiguration {
  services.nginx.appendHttpConfig = ''
    map $http_origin $allow_origin {
      ~^https://.+\.rgbcu.be$ $http_origin;
    }

    map $http_origin $allow_methods {
      ~^https://.+\.rgbcu.be$ "GET, HEAD, OPTIONS";
    }
  '';

  services.nginx.virtualHosts.${domain} = ulib.recursiveUpdateAll [ (sslTemplate domain) notFoundLocationConfig {
    root = "${path}";

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
  }];

  services.nginx.virtualHosts."www.${domain}" = (sslTemplate domain) // {
    locations."/".extraConfig = "return 301 https://${domain}$request_uri;";
  };

  services.nginx.virtualHosts._ = ulib.recursiveUpdateAll [ (sslTemplate domain) notFoundLocationConfig {
    root = "${path}";

    locations."/".extraConfig = "return 404;";
    locations."/assets/".extraConfig = "return 301 https://${domain}$request_uri;";
  }];
}
