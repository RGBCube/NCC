{ config, ulib, ... }: with ulib;

systemConfiguration {
  services.akkoma = { # enabled {
    nginx = {
      forceSSL   = true;
      enableACME = true;

      locations."/".proxyPass = "http://localhost:${toString cfg.port}";
    };

    config.":pleroma"."Pleroma.Web.Endpoint" = {
      http.ip = "::";
      url.host = "social.${config.networking.domain}";
      url.port = 4778;
    };
  };
}
