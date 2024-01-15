{ config, ulib, ... }: with ulib;

let
  inherit (config.networking) domain;

  fqdn = "metrics.${domain}";
in serverSystemConfiguration {
  age.secrets."cube/password.grafana" = {
    owner = "grafana";
    group = "grafana";
  };

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
      admin_password = "$__file{${config.age.secrets."cube/passowrd.grafana".path}}";

      disable_initial_admin_creation = true; # Just in case.
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
