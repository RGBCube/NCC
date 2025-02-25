{ self, config, lib, ... }: let
  inherit (config.networking) domain;
  inherit (lib) merge;

  fqdn = "cache.${domain}";
in {
  imports = [(self + /modules/nginx.nix)];

  services.nginx.virtualHosts.${fqdn} = merge config.services.nginx.sslTemplate {
    locations."/" = {
      extraConfig = /* nginx */ ''
        proxy_set_header Host "hercules.${config.services.garage.settings.s3_web.root_domain}";
      '';

      proxyPass = "http://${config.services.garage.settings.s3_web.bind_addr}";
    };
  };
}
