{ lib, ulib, pkgs, ... }: with ulib;

serverSystemConfiguration {
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.prometheus.exporters = {
    nginxlog = enabled {
      port = 9011;
    };

    nginx    = enabled {
      port = 9010;
    };
  };

  services.prometheus.scrapeConfigs = [{
    job_name = "nginx";

    static_configs = [{
      labels = [ "nginx" ];
      targets = [
        "[::]:${toString config.services.prometheus.exporters.nginxlog.port}"
        "[::]:${toString config.services.prometheus.exporters.nginx.port}"
      ];
    }];
  }];

  services.nginx = enabled {
    statusPage = true;

    recommendedGzipSettings  = true;
    recommendedOptimisation  = true;
    recommendedProxySettings = true;
    recommendedTlsSettings   = true;

    commonHttpConfig = let
      fileToList = file: lib.splitString "\n" (builtins.readFile file);

      cloudflareIpsV4 = fileToList (pkgs.fetchurl {
        url    = "https://www.cloudflare.com/ips-v4";
        sha256 = "0ywy9sg7spafi3gm9q5wb59lbiq0swvf0q3iazl0maq1pj1nsb7h";
      });
      cloudflareIpsV6 = fileToList (pkgs.fetchurl {
        url    = "https://www.cloudflare.com/ips-v6";
        sha256 = "1ad09hijignj6zlqvdjxv7rjj8567z357zfavv201b9vx3ikk7cy";
      });

      realIpsFromList = lib.concatMapStringsSep "\n" (ip: "set_real_ip_from ${ip};");
    in ''
      ${realIpsFromList cloudflareIpsV4}
      ${realIpsFromList cloudflareIpsV6}
      real_ip_header CF-Connecting-IP;
    '';

    appendHttpConfig = ''
      map $scheme $hsts_header {
          https "max-age=31536000; includeSubdomains; preload";
      }
      add_header Strict-Transport-Security $hsts_header;

      add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

      add_header "Referrer-Policy" "no-referrer";

      add_header X-Frame-Options DENY;

      add_header X-Content-Type-Options nosniff;

      proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
    '';
  };
}
