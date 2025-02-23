{ self, config, lib, ... }: let
  inherit (config.networking) domain;
  inherit (lib) enabled merge;

  root = "/var/www/site";
in {
  imports = [(self + /modules/nginx.nix)];

  services.nginx = enabled {
    virtualHosts.${domain} = merge config.services.nginx.sslTemplate {
      inherit root;

      locations."/".tryFiles = "$uri $uri.html $uri/index.html =404";

      extraConfig = /* nginx */ ''
        error_page 404 /404.html;
      '';

      locations."/404".extraConfig = /* nginx */ ''
        internal;
      '';
    };

    virtualHosts."www.${domain}" = merge config.services.nginx.sslTemplate {
      locations."/".return = "301 https://${domain}$request_uri";
    };

    virtualHosts._ = merge config.services.nginx.sslTemplate {
      locations."/".return = "301 https://${domain}/404";
    };
  };
}
