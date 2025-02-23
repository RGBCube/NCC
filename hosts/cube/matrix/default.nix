{ self, config, lib, ... }: let
  inherit (config.networking) domain;
  inherit (lib) const enabled genAttrs merge strings;

  pathSite = "/var/www/site";

  domainChat = "chat.${domain}";
  domainSync = "sync.${domain}";

  wellKnownResponse = data: ''
    default_type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${strings.toJSON data}';
  '';

  configClient."m.homeserver".base_url        = "https://${domainChat}";
  configClient."org.matrix.msc3575.proxy".url = "https://${domainSync}";

  configServer."m.server" = "${domainChat}:443";

  configWellKnownResponse.locations = {
    "= /.well-known/matrix/client".extraConfig = wellKnownResponse configClient;
    "= /.well-known/matrix/server".extraConfig = wellKnownResponse configServer;
  };

  configNotFoundLocation = {
    locations."/".extraConfig = "return 404;";

    extraConfig                  = "error_page 404 /404.html;";
    locations."/404".extraConfig = "internal;";

    locations."/assets/".extraConfig = "return 301 https://${domain}$request_uri;";
  };

  portSynapse = 8002;
  portSync    = 8003;
in {
  imports = [(self + /modules/nginx.nix)];

  secrets.matrixSecret = {
    file  = ./password.secret.age;
    owner = "matrix-synapse";
  };
  secrets.matrixSyncPassword = {
    file  = ./password.sync.age;
    owner = "matrix-synapse";
  };

  services.postgresql = let
    users = [ "matrix-synapse" "matrix-sliding-sync" ];
  in {
    ensureDatabases = users;
    ensureUsers     = map users (name: {
      inherit name;

      ensureDBOwnership = true;
    });
  };

  services.restic.backups = genAttrs config.services.restic.hosts <| const {
    paths = [ "/var/lib/matrix-synapse"  "/var/lib/matrix-sliding-sync" ];
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
      port = portSynapse;

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

  services.nginx.virtualHosts.${domainChat} = merge config.services.nginx.sslTemplate configWellKnownResponse configNotFoundLocation {
    root = "${pathSite}";

    locations."/_matrix".proxyPass         = "http://[::1]:${toString portSynapse}";
    locations."/_synapse/client".proxyPass = "http://[::1]:${toString portSynapse}";
  };

  services.matrix-sliding-sync = enabled {
    environmentFile = config.age.secrets.matrixSyncPassword.path;
    settings        = {
      SYNCV3_SERVER   = "https://${domainChat}";
      SYNCV3_DB       = "postgresql:///matrix-sliding-sync?host=/run/postgresql";
      SYNCV3_BINDADDR = "[::1]:${toString portSync}";
    };
  };

  services.nginx.virtualHosts.${domainSync} = merge config.services.nginx.sslTemplate configNotFoundLocation {
    root = pathSite;

    locations."~ ^/(client/|_matrix/client/unstable/org.matrix.msc3575/sync)"
      .proxyPass = "http://[::1]:${toString portSynapse}";

    locations."~ ^(\\/_matrix|\\/_synapse\\/client)"
      .proxyPass = "http://[::1]:${toString portSync}";
  };
}
