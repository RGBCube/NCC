{ self, config, lib, ... }: let
  inherit (config.networking) domain;
  inherit (lib) enabled merge;

  pathSite = "/var/www/site";

  configNotFoundLocation = {
    extraConfig = /* nginx */ ''
      error_page 404 /404.html;
    '';

    locations."/404".extraConfig = /* nginx */ ''
      internal;
    '';
  };
in {
  imports = [(self + /modules/nginx.nix)];

  services.nginx = enabled {
    virtualHosts.${domain} = merge config.services.nginx.sslTemplate configNotFoundLocation {
      root = pathSite;

      locations."/".tryFiles = "$uri $uri.html $uri/index.html =404";

      locations."/assets/".extraConfig = /* nginx */ ''
        if ($request_method = OPTIONS) {
          ${config.services.nginx.headers}
          add_header Content-Type text/plain always;
          add_header Content-Length 0 always;
          return 204;
        }

        expires 24h;
      '';
    };

    virtualHosts."www.${domain}" = merge config.services.nginx.sslTemplate {
      locations."/".extraConfig = /* nginx */ ''
        return 301 https://${domain}$request_uri;
      '';
    };

    virtualHosts._ = merge config.services.nginx.sslTemplate configNotFoundLocation {
      root = pathSite;

      locations."/".extraConfig = /* nginx */ ''
        return 404;
      '';

      locations."/assets/".extraConfig = /* nginx */ ''
        return 301 https://${domain}$request_uri;
      '';
    };
  };
}
