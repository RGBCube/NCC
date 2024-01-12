{ config, ulib, ... }: with ulib;

let
  inherit (config.networking) domain;

  fqdn = "metrics.${domain}";
in serverSystemConfiguration {
  age.secrets."cube.mail.password" = {
    owner = "grafana";
    group = "grafana";
  };

  services.grafana = enabled {
    domain = fqdn;
    port   = 8999;

    settings.security = {
      admin_email    = "metrics@${domain}";
      admin_password = "$__file{${config.age.secrets."cube.mail.password".path}}";
    };

    settings.server.http_addr = "::";

    settings.users = {
      default_theme = "system";
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
