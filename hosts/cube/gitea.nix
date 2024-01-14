{ config, ulib, ... }: with ulib;

let
  inherit (config.networking) domain;

  fqdn = "git.${domain}";
in serverSystemConfiguration {
  services.gitea = { # enabed {
    lfs = enabled {};

    database = {
      socket = "/run/postgresql";
      type   = "postgres";
    };

    settings = {
      APP_NAME = "RGBCube's Git Server";

      server.DOMAIN                = fqdn;
      server.HTTP_ADDR             = "::";
      server.SSH_PORT              = builtins.elemAt config.services.openssh.port 0;

      service.DISABLE_REGISTRATION = true;
      session.COOKIE_SECURE        = true;
    };
  };
}
