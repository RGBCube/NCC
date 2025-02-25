{ self, config, lib, pkgs, ... }: let
  inherit (config.networking) domain;
  inherit (lib) enabled merge;

  fqdn    = "s3.${domain}";
  portS3  = 8004;
  portRpc = 8005;
in {
  imports = [(self + /modules/nginx.nix)];

  secrets.garageEnvironment.file  = ./environment.age;

  services.garage = enabled {
    package = pkgs.garage_1_0_1;

    environmentFile = config.secrets.garageEnvironment.path;

    settings = {
      data_dir = [{
        capacity = "2T";
        path     = "/var/lib/garage/data";
      }];

      replication_factor = 1; # TODO: Expand.
      consistency_mode   = "consistent";

      metadata_fsync = true;
      data_fsync     = true;

      rpc_bind_addr   = "[::]:${toString portRpc}";

      s3_api = {
        s3_region = "garage";

        api_bind_addr = "[::1]:${toString portS3}";
        root_domain   = fqdn;
      };
    };
  };

  services.nginx.virtualHosts.${fqdn} = merge config.services.nginx.sslTemplate {
    locations."/".proxyPass = "http://[::1]:${toString portS3}";
  };
}
