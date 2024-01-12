{ config, lib, ulib, ... }: with ulib;

let
  inherit (config.networking) domain;

  fqdn = "paste.${domain}";
  port = 4778;
in serverSystemConfiguration {
  services.nginx.virtualHosts.${fqdn} = {
    forceSSL    = true;
    useACMEHost = domain;

    locations."/".proxyPass = "http://[::1]:${toString port}/";
  };

  services.microbin = enabled {
    passwordFile = config.age.secrets."cube.microbin.password".path;

    settings = lib.mapAttrs' (name: value: lib.nameValuePair "MICROBIN_${lib.toUpper name}" (toString value)) {
      inherit port;

      bind = "::1";

      title = "Paste - RGBCube";

      hide_footer = true;
      hide_header = true;
      hide_logo   = true;

      no_file_upload = true;
      no_listing     = true;

      hash_ids    = true;
      public_path = "https://${fqdn}/";
      qr          = true;

      enable_burn_after      = true;

      disable_telemetry       = true;
      disable_update_checking = true;
    };
  };
}
