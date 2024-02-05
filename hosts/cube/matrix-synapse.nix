{ config, ulib, ... }: with ulib;

let
  inherit (config.networking) domain;

  chatDomain = "chat.${domain}";
  syncDomain = "sync.${domain}";

  wellKnownResponse = data: ''
    default_type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';

  clientConfig."m.homeserver".base_url        = "https://${chatDomain}";
  clientConfig."org.matrix.msc3575.proxy".url = "https://${syncDomain}";
  serverConfig."m.server" = "${chatDomain}:443";

  synapsePort = 8001;
  syncPort    = 8002;
in serverSystemConfiguration {
  age.secrets."cube/password.secret.matrix-synapse".owner = "matrix-synapse";
  age.secrets."cube/password.sync.matrix-synapse".owner   = "matrix-synapse";

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

      allow_guest_access  = false;
      enable_registration = false;

      expire_access_token = true;
      url_preview_enabled = true;

      # Trusting Matrix.org.
      suppress_key_server_warning = true;
    };

    # Sets registration_shared_secret.
    extraConfigFiles = [ config.age.secrets."cube/password.secret.matrix-synapse".path ];

    settings.listeners = [{
      port = synapsePort;

      bind_addresses = [ "::" ];
      tls            = false;
      type           = "http";
      x_forwarded    = true;

      resources = [{
        compress = false;
        names    = [ "client" "federation" ];
      }];
    }];
  };

  services.nginx.virtualHosts.${domain}.locations =  {
    "= /.well-known/matrix/client".extraConfig = wellKnownResponse clientConfig;
    "= /.well-known/matrix/server".extraConfig = wellKnownResponse serverConfig;
  };

  services.nginx.virtualHosts.${chatDomain} = (sslTemplate domain) // {
    locations."= /.well-known/matrix/client".extraConfig = wellKnownResponse clientConfig;
    locations."= /.well-known/matrix/server".extraConfig = wellKnownResponse serverConfig;

    locations."/_matrix".proxyPass         = "http://[::]:${toString synapsePort}";
    locations."/_synapse/client".proxyPass = "http://[::]:${toString synapsePort}";

    locations."/".proxyPass = "http://[::]:${toString config.services.site.port}/404/";
    locations."/assets"     = {
      proxyPass   = "http://[::]:${toString config.services.site.port}/assets";
      extraConfig = ''
        add_header Cache-Control "public, max-age=10800, immutable";
      '';
    };
  };

  services.matrix-sliding-sync = enabled {
    environmentFile = config.age.secrets."cube/password.sync.matrix-synapse".path;
    settings        = {
      SYNCV3_SERVER   = "https://${chatDomain}";
      SYNCV3_DB       = "postgresql:///matrix-sliding-sync?host=/run/postgresql";
      SYNCV3_BINDADDR = "[::]:${toString syncPort}";
    };
  };

  services.nginx.virtualHosts.${syncDomain} = (sslTemplate domain) // {
    locations."~ ^/(client/|_matrix/client/unstable/org.matrix.msc3575/sync)"
      .proxyPass = "http://[::]:${toString synapsePort}";

    locations."~ ^(\\/_matrix|\\/_synapse\\/client)"
      .proxyPass = "http://[::]:${toString syncPort}";

    locations."/".proxyPass = "http://[::]:${toString config.services.site.port}/404/";
    locations."/assets"     = {
      proxyPass   = "http://[::]:${toString config.services.site.port}/assets";
      extraConfig = ''
        add_header Cache-Control "public, max-age=10800, immutable";
      '';
    };
  };
}
