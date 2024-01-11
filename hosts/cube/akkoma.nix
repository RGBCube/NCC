{ config, ulib, ... }: with ulib;

serverSystemConfiguration {
  services.akkoma = let
    inherit ((pkgs.formats.elixirConf { }).lib) mkRaw mkTuple;

    port = 4778;
  in { # enabled {
    nginx = {
      forceSSL   = true;
      enableACME = true;
    };

    config.":pleroma" = {
      ":rich_media".enabled                = true;
      ":static_fe".enabled                 = true;
      "Pleroma.Captcha".enabled            = false;
      "Pleroma.Emails.Mailer".enabled      = false;
      "Pleroma.Web.Plugs.RemoteIp".enabled = true;
    };

    config.":pleroma".":assets".mascots = [{
      url       = "https://social.${config.networking.domain}/static/cube.gif"; # TODO
      mime_type = "image/gif";
    }];

    config.":pleroma".":instance" = {
      name        = "RGBCube's Akkoma Server";
      description = "RGBCube's Akkoma server, facism edition.";

      email        = "social@rgbcu.be";
      notify_email = "social@rgbcu.be";

      limit        = 100000;
      remote_limit = 100000;

      upload_limit = 100000000; # 100MiB
      cleanup_attachments = true;

      registrations_open = false;
      invites_enabled    = true;

      max_pinned_statuses = 10;

      safe_dm_mention = true;
      healthcheck = true;

      limit_to_local_content       = mkRaw ":unauthenticated";
      external_user_syncronization = true;
    };

    config.":pleroma".":ldap" = {
      enabled = true;
      host = "127.0.0.1";
      # Continue...
    };

    config.":pleroma".":rate_limit" = let
      ratelimit = unauth: auth: [(mkTuple [1000 unauth]) (mkTuple [1000 auth])];
    in {
      authentication = mkTuple [60000 3];
      timeline       = ratelimit 3 5;
      search         = ratelimit 3 10;
    };

    config.":pleroma"."Pleroma.Web.Endpoint" = {
      http.ip  = "::";
      http.port = port;
      url.host = "social.${config.networking.domain}";
      url.port = 443;
    };
  };
}
