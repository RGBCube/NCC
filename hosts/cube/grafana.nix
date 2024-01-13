{ config, pkgs, ulib, ... }: with ulib;

let
  inherit (config.networking) domain;

  fqdn = "metrics.${domain}";
in serverSystemConfiguration {
  age.secrets."cube.mail.password" = {
    owner = "grafana";
    group = "grafana";
  };

  services.postgresql = {
    ensureDatabases = [ "grafana" ];
    initialScript   = pkgs.writeText "postgresql-initial-script" ''
      CREATE ROLE grafana WITH LOGIN PASSWORD NULL CREATEDB;
      GRANT ALL PRIVILEGES ON DATABASE grafana TO grafana;
    '';
  };

  services.grafana = enabled {
    domain = fqdn;
    port   = 8999;

    settings = {
      database.host = "/run/postgresql";
      database.type = "postgres";
      database.user = "grafana";

      server.http_addr    = "::";
      users.default_theme = "system";
    };

    settings.security = {
      admin_email    = "metrics@${domain}";
      admin_password = "$__file{${config.age.secrets."cube.mail.password".path}}";
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
