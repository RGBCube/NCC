 { config, ulib, pkgs, ... }: with ulib;

let
  inherit (config.networking) domain;

  fqdn = "cloud.${domain}";
in serverSystemConfiguration {
  age.secrets."cube/password.nextcloud" = {
    owner = "nextcloud";
    group = "nextcloud";
  };

  services.nextcloud = enabled {
    package  = pkgs.nextcloud28;

    hostName = fqdn;
    https    = true;

    configureRedis = true;

    config.adminuser     = "admin";
    config.adminpassFile = config.age.secrets."cube/password.nextcloud".path;

    config.dbtype          = "pgsql";
    database.createLocally = true;

    extraAppsEnable = true;
    extraApps       = {
      inherit (config.services.nextcloud.package.packages.apps)
        bookmarks calendar contacts deck 
        forms groupfolders impersonate
        mail maps notes phonetrack
        polls previewgenerator tasks;
        # Add: files_markdown files_texteditor memories news
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

    nginx.recommendedHttpHeaders = true;
  };

  services.nginx.virtualHosts.${fqdn} = {
    forceSSL    = true;
    useACMEHost = domain;
  };
}
