{ self, config, lib, pkgs, ... }: let
  inherit (config.networking) domain;
  inherit (lib) enabled merge;

  fqdn = "cache.${domain}";

  portNixServe = 8006;
in {
  imports = [(self + /modules/nginx.nix)];

  secrets.nixServeKey = {
    file  = ./key.age;
    owner = "root"; # `nix-serve` runs as root.
  };

  services.nix-serve = enabled {
    package       = pkgs.nix-serve-ng;
    secretKeyFile = config.secrets.nixServeKey.path;

    # Not ::1 because nix-serve doesn't like that.
    bindAddress = "127.0.0.1";
    port        = portNixServe;
  };

  services.nginx.virtualHosts.${fqdn} = merge config.services.nginx.sslTemplate {
    extraConfig = /* nginx */ ''
      proxy_intercept_errors on;
      error_page 404 = @fallback;
    '';

    locations."= /".return = "301 https://${domain}/404";

    locations."/".proxyPass = "http://127.0.0.1:${toString portNixServe}";

    locations."@fallback" = {
      extraConfig = /* nginx */ ''
        proxy_set_header Host "hercules.${config.services.garage.settings.s3_web.root_domain}";
      '';

      proxyPass = "http://${config.services.garage.settings.s3_web.bind_addr}";
    };
  };
}
