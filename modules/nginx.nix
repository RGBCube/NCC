{ config, lib, pkgs, ... }: let
  inherit (config.networking) domain;
  inherit (lib) enabled mkConst;
in {
  options.nginx.sslTemplate = mkConst {
    forceSSL    = true;
    quic        = true;
    useACMEHost = config.networking.domain;
  };

  options.nginx.headers = mkConst ''
    # TODO: Not working for some reason.
    add_header Access-Control-Allow-Origin $allow_origin;
    add_header Access-Control-Allow-Methods $allow_methods;

    add_header Strict-Transport-Security $hsts_header;

    add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

    add_header Referrer-Policy no-referrer;

    add_header X-Frame-Options DENY;

    add_header X-Content-Type-Options nosniff;
  '';

  config.networking.firewall = {
    allowedTCPPorts = [ 443 80 ];
    allowedUDPPorts = [ 443 ];
  };

  config.services.prometheus.exporters.nginx = enabled {
    listenAddress = "[::]";
  };

  config.security.acme.users = [ "nginx" ];

  config.services.nginx = enabled {
    package = pkgs.nginxQuic;

    statusPage = true;

    recommendedBrotliSettings = true;
    recommendedGzipSettings   = true;
    recommendedZstdSettings   = true;

    recommendedOptimisation   = true;
    recommendedProxySettings  = true;
    recommendedTlsSettings    = true;

    commonHttpConfig = ''
      map $scheme $hsts_header {
        https "max-age=31536000; includeSubdomains; preload";
      }

      map $http_origin $allow_origin {
        ~^https://.+\.${domain}$ $http_origin;
      }

      map $http_origin $allow_methods {
        ~^https://.+\.${domain}$ "GET, HEAD, OPTIONS";
      }

      ${config.nginx.headers}

      proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
    '';
  };
}
