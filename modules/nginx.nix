{ config, lib, pkgs, ... }: let
  inherit (lib) enabled mkConst;
in {
  options.nginxSslTemplate = mkConst {
    forceSSL    = true;
    quic        = true;
    useACMEHost = config.networking.domain;
  };

  options.nginxHeaders = mkConst ''
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

  config.acmeUsers = [ "nginx" ];

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

      ${config.nginxHeaders}

      proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
    '';
  };
}
