{ config, ulib, ... }: with ulib;

let
  inherit (config.networking) domain;

  port = 8003;
in serverSystemConfiguration {
  services.site = enabled {
    inherit port;
  };

  services.nginx.virtualHosts.${domain} = (sslTemplate domain) // {
    locations."/".proxyPass = "http://[::]:${toString port}";
  };

  services.nginx.virtualHosts."www.${domain}" = (sslTemplate domain) // {
    locations."/".extraConfig = ''
      return 301 https://${domain}$request_uri;
    '';
  };

  services.nginx.virtualHosts._ = (sslTemplate domain) // {
    locations."/".proxyPass       = "http://[::]:${toString port}/404/";
    locations."/assets".proxyPass = "http://[::]:${toString port}/assets";
  };
}
