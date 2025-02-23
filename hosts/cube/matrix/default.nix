{ self, config, lib, ... }: let
  inherit (config.networking) domain;
  inherit (lib) const enabled genAttrs merge strings;

  pathSite = "/var/www/site";

  fqdn = "chat.${domain}";
  port = 8002;

  configClient."m.homeserver".base_url        = "https://${fqdn}";
  configServer."m.server" = "${fqdn}:443";

  configWellKnownResponse.locations = let
    wellKnownResponse = data: ''
      default_type application/json;
      add_header Access-Control-Allow-Origin *;
      return 200 '${strings.toJSON data}';
    '';
  in {
    "= /.well-known/matrix/client".extraConfig = wellKnownResponse configClient;
    "= /.well-known/matrix/server".extraConfig = wellKnownResponse configServer;
  };

  configNotFoundLocation = {
    locations."/".extraConfig = "return 404;";

    extraConfig                  = "error_page 404 /404.html;";
    locations."/404".extraConfig = "internal;";

    locations."/assets/".extraConfig = "return 301 https://${domain}$request_uri;";
  };
in {
  imports = [(self + /modules/nginx.nix)];

  secrets.matrixSecret = {
    file  = ./password.secret.age;
    owner = "matrix-synapse";
  };

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

      report_stats = false;

      enable_metrics = true;
      metrics_flags.known_servers = true;

      expire_access_token = true;
      url_preview_enabled = true;

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

  services.nginx.virtualHosts.${fqdn} = merge config.services.nginx.sslTemplate configWellKnownResponse configNotFoundLocation {
    root = "${pathSite}";

    locations."/_matrix".proxyPass         = "http://[::1]:${toString port}";
    locations."/_synapse/client".proxyPass = "http://[::1]:${toString port}";
  };
}
