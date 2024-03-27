{ lib, pkgs, ... }: with lib;

let
  prometheusPort = 9030;
in systemConfiguration {
  networking.firewall = {
    allowedTCPPorts = [ 443 80 ];
    allowedUDPPorts = [ 443 ];
  };

  services.prometheus = {
    exporters.nginx = enabled {
      listenAddress = "[::1]";
      port          = prometheusPort;
    };

    scrapeConfigs = [{
      job_name = "nginx";

      static_configs = [{
        labels.job = "nginx";
        targets    = [ "[::1]:${toString prometheusPort}" ];
      }];
    }];
  };

  services.nginx = enabled {
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
      add_header Strict-Transport-Security $hsts_header;

      # add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

      add_header Referrer-Policy no-referrer;

      # add_header X-Frame-Options DENY;

      # add_header X-Content-Type-Options nosniff;

      proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
    '';
  };
}
