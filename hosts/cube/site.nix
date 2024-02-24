{ config, ulib, ... }: with ulib;

let
  inherit (config.networking) domain;

  path = "/var/www/site";

  assetsLocation = {
    locations."/assets/" = {
      alias       = "${path}/assets/";
      extraConfig = ''
        add_header Cache-Control "public, max-age=86400, immutable";
      '';
    };
  };
in serverSystemConfiguration {
  services.nginx.virtualHosts.${domain} = (sslTemplate domain) // assetsLocation // {
    locations."/" = {
      alias    = "${path}/";
      tryFiles = "$uri $uri/ $uri.html $uri/index.html =404";
    };
  };

  services.nginx.virtualHosts."www.${domain}" = (sslTemplate domain) // {
    locations."/".extraConfig = ''
      return 301 https://${domain}$request_uri;
    '';
  };

  services.nginx.virtualHosts._ = (sslTemplate domain) // assetsLocation // {
    locations."/".alias = "${path}/404.html";
  };
}
