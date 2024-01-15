 { config, ulib, pkgs, ... }: with ulib;

let
  inherit (config.networking) domain;

  fqdn = "cloud.${domain}";
in serverSystemConfiguration {
  age.secrets."cube/password.nextcloud" = {
    owner = "nextcloud";
    group = "nextcloud";
  };

  age.secrets."cube/password.mail.nextcloud" = {
    owner = "nextcloud";
    group = "nextcloud";
  };

  systemd.services.nextcloud-setup.requires = [ "postgresql.service" ];

  services.nextcloud = enabled {
    package  = pkgs.nextcloud28;

    hostName = fqdn;
    https    = true;

    configureRedis = true;

    config.adminuser     = "admin";
    config.adminpassFile = config.age.secrets."cube/password.nextcloud".path;

    config.dbhost = "/run/postgresql";
    config.dbtype = "pgsql";

    secretFile = config.age.secrets."cube/password.mail.nextcloud".path;
    extraOptions = {
      mail_domain   = domain;
      mail_smtphost = domain;

      mail_from_address = "cloud";
      mail_smtpname     = "contact";

      mail_smtpauth   = true;
      mail_smtpsecure = "ssl";
    };

    extraOptions.enabledPreviewProviders = [
      "OC\\Preview\\BMP"
      "OC\\Preview\\GIF"
      "OC\\Preview\\JPEG"
      "OC\\Preview\\Krita"
      "OC\\Preview\\MarkDown"
      "OC\\Preview\\MP3"
      "OC\\Preview\\OpenDocument"
      "OC\\Preview\\PNG"
      "OC\\Preview\\TXT"
      "OC\\Preview\\XBitmap"
      "OC\\Preview\\HEIC"
    ];

    extraAppsEnable = true;
    extraApps       = {
      inherit (config.services.nextcloud.package.packages.apps)
        bookmarks calendar contacts deck
        forms groupfolders impersonate
        mail maps notes phonetrack
        polls previewgenerator tasks;
        # Add: files_markdown files_texteditor memories news
    };

    nginx.recommendedHttpHeaders = true;
  };

  services.nginx.virtualHosts.${fqdn} = {
    forceSSL    = true;
    useACMEHost = domain;
  };
}
