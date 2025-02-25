{ self, config, lib, pkgs, ... }: let
  inherit (config.networking) domain;
  inherit (lib) enabled merge;

  fqdn = "cache.${domain}";
  port = 8003;
in {
  imports = [(self + /modules/nginx.nix)];

  secrets.nixServeKey = {
    file  = ./key.age;
    owner = "nix-serve";
  };

  services.nix-serve = enabled {
    package       = pkgs.nix-serve-ng;
    secretKeyFile = config.secrets.nixServeKey.path;

    # Not ::1 because nix-serve doesn't like that.
    bindAddress = "127.0.0.1";
    inherit port;
  };

  services.nginx.virtualHosts.${fqdn} = merge config.services.nginx.sslTemplate {
    locations."/".proxyPass = "http://127.0.0.1:${toString port}";
  };
}
