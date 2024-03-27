{ config, ulib, ... }: with ulib;

let
  inherit (config.networking) domain;

  fqdn = "metrics.${domain}";
in serverSystemConfiguration {
  age.secrets."hosts/cube/grafana/password" = {
    file  = ./password.age;
    owner = "grafana";
  };
  age.secrets."hosts/cube/grafana/password.mail" = {
    file  = ./password.mail.age;
    owner = "grafana";
  };

  services.fail2ban.jails.grafana.settings = {
    filter       = "grafana";
    journalmatch = "_SYSTEMD_UNIT=grafana.service";
    maxretry     = 3;
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
      server.http_addr = "[::]";
      server.http_port = 8000;

      users.default_theme = "system";
    };

    settings.security = {
      admin_email    = "metrics@${domain}";
      admin_password = "$__file{${config.age.secrets."hosts/cube/grafana/password".path}}";
      admin_user     = "admin";

      cookie_secure    = true;
      disable_gravatar = true;

      disable_initial_admin_creation = true; # Just in case.
    };

    settings.smtp = {
      enabled = true;

      password        = "$__file{${config.age.secrets."hosts/cube/grafana/password.mail".path}}";
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
