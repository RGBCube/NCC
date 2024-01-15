{ config, ulib, ... }: with ulib;

let
  inherit (config.networking) domain;

  fqdn = "metrics.${domain}";
in serverSystemConfiguration {
  age.secrets."cube/password.grafana" = {
    owner = "grafana";
    group = "grafana";
  };

  age.secrets."cube/password.mail.grafana" = {
    owner = "grafana";
    group = "grafana";
  };

  systemd.services.grafana.requires = [ "postgresql.service" ];

  services.grafana = enabled {
    domain = fqdn;
    port   = 8999;

    analytics.reporting.enable = false;

    provision = enabled {};

    settings = {
      database.host = "/run/postgresql";
      database.type = "postgres";
      database.user = "grafana";

      server.http_addr    = "::";
      users.default_theme = "system";
    };

    settings.security = {
      admin_email    = "metrics@${domain}";
      admin_password = "$__file{${config.age.secrets."cube/password.grafana".path}}";
      admin_user     = "admin";

      disable_initial_admin_creation = true; # Just in case.
    };

    settings.smtp = enabled {
      password        = "$__file{${config.age.secrets."cube/password.mail.grafana".path}}";
      startTLS_policy = "MandatoryStartTLS";

      ehlo_identity = "metrics@${domain}";
      from_address  = "contact@${domain}";
      from_name     = "Metrics";
      host          = domain;
    };
  };

  services.nginx.virtualHosts.${fqdn} = {
    forceSSL    = true;
    useACMEHost = domain;

    locations."/" = {
      proxyPass       = "http://[::]:${toString config.services.grafana.port}";
      proxyWebsockets = true;
    };
  };
}
