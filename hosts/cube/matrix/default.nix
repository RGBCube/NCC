{ config, lib, ... }: with lib;

let
  inherit (config.networking) domain;

  sitePath = "/var/www/site";

  chatDomain = "chat.${domain}";
  syncDomain = "sync.${domain}";

  wellKnownResponse = data: ''
    default_type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${strings.toJSON data}';
  '';

  clientConfig."m.homeserver".base_url        = "https://${chatDomain}";
  clientConfig."org.matrix.msc3575.proxy".url = "https://${syncDomain}";

  serverConfig."m.server" = "${chatDomain}:443";

  wellKnownResponseConfig.locations = {
    "= /.well-known/matrix/client".extraConfig = wellKnownResponse clientConfig;
    "= /.well-known/matrix/server".extraConfig = wellKnownResponse serverConfig;
  };

  notFoundLocationConfig = {
    locations."/".extraConfig = "return 404;";

    extraConfig                  = "error_page 404 /404.html;";
    locations."/404".extraConfig = "internal;";

    locations."/assets/".extraConfig = "return 301 https://${domain}$request_uri;";
  };

  synapsePort = 8002;
  syncPort    = 8003;
in serverSystemConfiguration {
  secrets.matrixSecret = {
    file  = ./password.secret.age;
    owner = "matrix-synapse";
  };
  secrets.matrixSyncPassword = {
    file  = ./password.sync.age;
    owner = "matrix-synapse";
  };

  services.postgresql = {
    ensureDatabases = [ "matrix-synapse" "matrix-sliding-sync" ];
    ensureUsers     = [
      {
        name = "matrix-synapse";
        ensureDBOwnership = true;
      }
      {
        name = "matrix-sliding-sync";
        ensureDBOwnership = true;
      }
    ];
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
      port = synapsePort;

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

  services.nginx.virtualHosts.${domain} = wellKnownResponseConfig;

  services.nginx.virtualHosts.${chatDomain} = merge config.sslTemplate wellKnownResponseConfig notFoundLocationConfig {
    root = "${sitePath}";

    locations."/_matrix".proxyPass         = "http://[::1]:${toString synapsePort}";
    locations."/_synapse/client".proxyPass = "http://[::1]:${toString synapsePort}";
  };

  services.matrix-sliding-sync = enabled {
    environmentFile = config.age.secrets.matrixSyncPassword.path;
    settings        = {
      SYNCV3_SERVER   = "https://${chatDomain}";
      SYNCV3_DB       = "postgresql:///matrix-sliding-sync?host=/run/postgresql";
      SYNCV3_BINDADDR = "[::1]:${toString syncPort}";
    };
  };

  services.nginx.virtualHosts.${syncDomain} = merge config.sslTemplate notFoundLocationConfig {
    root = sitePath;

    locations."~ ^/(client/|_matrix/client/unstable/org.matrix.msc3575/sync)"
      .proxyPass = "http://[::1]:${toString synapsePort}";

    locations."~ ^(\\/_matrix|\\/_synapse\\/client)"
      .proxyPass = "http://[::1]:${toString syncPort}";
  };
}
