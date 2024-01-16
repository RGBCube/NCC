{ config, lib, ulib, pkgs, ... }: with ulib;

serverSystemConfiguration {
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.prometheus = {
    exporters.nginx = enabled {
      port = 9030;
    };

    scrapeConfigs = [{
      job_name = "nginx";

      static_configs = [{
        labels.job = "nginx";
        targets    = [ "[::]:${toString config.services.prometheus.exporters.nginx.port}" ];
      }];
    }];
  };

  services.nginx = enabled {
    statusPage = true;

    recommendedBrotliSettings = true;
    recommendedGzipSettings   = true;
    recommendedZstdSettings   = true;

    recommendedOptimisation   = true;
    recommendedProxySettings  = true;
    recommendedTlsSettings    = true;

    appendHttpConfig = ''
      map $scheme $hsts_header {
          https "max-age=31536000; includeSubdomains; preload";
      }
      add_header Strict-Transport-Security $hsts_header;

      # add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

      add_header "Referrer-Policy" "no-referrer";

      add_header X-Frame-Options DENY;

      add_header X-Content-Type-Options nosniff;

      proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
    '';
  };
}
