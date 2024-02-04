{ config, ulib, ... }: with ulib;

let
  inherit (config.networking) domain;

  fqdn = "metrics.${domain}";
in serverSystemConfiguration {
  age.secrets."cube/password.grafana".owner      = "grafana";
  age.secrets."cube/password.mail.grafana".owner = "grafana";

  services.fail2ban.jails.grafana.settings = {
    filter   = "grafana";
    maxretry = 3;
  };

  services.postgresql = {
    ensureDatabases = [ "grafana" ];
    ensureUsers     = [{
      name = "grafana";
      ensureDBOwnership = true;
    }];
  };

  systemd.services.grafana = {
    after    = [ "postgresql.service" ];
    requires = [ "postgresql.service" ];
  };

  services.grafana = enabled {
    provision = enabled {};

    settings = {
      analytics.reporting_enabled = false;

      database.host = "/run/postgresql";
      database.type = "postgres";
      database.user = "grafana";

      server.domain    = fqdn;
      server.http_addr = "::";
      server.http_port = 8000;

      users.default_theme = "system";
    };

    settings.security = {
      admin_email    = "metrics@${domain}";
      admin_password = "$__file{${config.age.secrets."cube/password.grafana".path}}";
      admin_user     = "admin";

      cookie_secure    = true;
      disable_gravatar = true;

      disable_initial_admin_creation = true; # Just in case.
    };

    settings.smtp = {
      enabled = true;

      password        = "$__file{${config.age.secrets."cube/password.mail.grafana".path}}";
      startTLS_policy = "MandatoryStartTLS";

      ehlo_identity = "contact@${domain}";
      from_address  = "metrics@${domain}";
      from_name     = "Metrics";
      host          = "${config.mailserver.fqdn}:${toString config.services.postfix.relayPort}";
    };
  };

  services.nginx.virtualHosts.${fqdn} = (sslTemplate domain) // {
    locations."/" = {
      proxyPass       = "http://[::]:${toString config.services.grafana.settings.server.http_port}";
      proxyWebsockets = true;
    };
  };
}
