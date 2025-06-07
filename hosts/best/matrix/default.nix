{ self, config, lib, ... }: let
  inherit (config.networking) domain;
  inherit (lib) const enabled genAttrs merge;
  inherit (lib.strings) toJSON;

  fqdn = "chat.${domain}";
  port = 8002;

  wellKnownResponse = data: /* nginx */ ''
    ${config.services.nginx.headers}
    add_header Access-Control-Allow-Origin * always;

    default_type application/json;
    return 200 '${toJSON data}';
  '';

  configWellKnownResponse.locations = {
    "= /.well-known/matrix/client".extraConfig = wellKnownResponse {
      "m.homeserver".base_url = "https://${fqdn}";
    };

    "= /.well-known/matrix/server".extraConfig = wellKnownResponse {
      "m.server" = "${fqdn}:443";
    };
  };
in {
  imports = [
    (self + /modules/nginx.nix)
    (self + /modules/postgresql.nix)
  ];

  secrets.matrixSecret = {
    file  = ./password.secret.age;
    owner = "matrix-synapse";
  };

  services.postgresql.ensure = [ "matrix-synapse" ];

  services.restic.backups = genAttrs config.services.restic.hosts <| const {
    paths = [ "/var/lib/matrix-synapse" ];
  };

  services.matrix-synapse = enabled {
    withJemalloc = true;

    configureRedisLocally  = true;
    settings.redis.enabled = true;

    extras = [ "postgres" "url-preview" "user-search" ];

    log.root.level = "WARNING"; # Shut the fuck up.

    settings = {
      server_name = domain;
      # We are not setting web_client_location since the root is not accessible
      # from the outside web at all. Only /_matrix is reverse proxied to.

      database.name  = "psycopg2";
      max_upload_size = "512M";

      report_stats = false;

      enable_metrics = true;
      metrics_flags.known_servers = true;

      url_preview_enabled = true;
      dynamic_thumbnails = true;

      expire_access_token = true;

      # Trusting Matrix.org.
      suppress_key_server_warning = true;
    };

    # Sets registration_shared_secret.
    extraConfigFiles = [ config.secrets.matrixSecret.path ];

    settings.listeners = [{
      inherit port;

      bind_addresses = [ "::1" ];
      tls            = false;
      type           = "http";
      x_forwarded    = true;

      resources = [{
        compress = false;
        names    = [ "client" "federation" ];
      }];
    }];
  };

  services.nginx.virtualHosts.${domain} = configWellKnownResponse;

  services.nginx.virtualHosts.${fqdn} = merge config.services.nginx.sslTemplate configWellKnownResponse {
    extraConfig = /* nginx */ ''
      client_max_body_size ${config.services.matrix-synapse.settings.max_upload_size};
    '';

    locations."/".return = "301 https://${domain}/404";

    locations."/_matrix".proxyPass         = "http://[::1]:${toString port}";
    locations."/_synapse/client".proxyPass = "http://[::1]:${toString port}";
  };
}
