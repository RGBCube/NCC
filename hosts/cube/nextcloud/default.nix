 { config, lib, pkgs, ... }: with lib;

let
  inherit (config.networking) domain;

  fqdn = "cloud.${domain}";

  prometheusPort = 9060;

  nextcloudPackage = pkgs.nextcloud28;
in systemConfiguration {
  secrets.nextcloudPassword = {
    file  = ./password.age;
    owner = "nextcloud";
  };
  secrets.nextcloudExporterPassword = {
    file  = ./password.age;
    owner = "nextcloud-exporter";
  };

  services.prometheus = {
    exporters.nextcloud = enabled {
      listenAddress = "[::1]";
      port          = prometheusPort;

      username     = "admin";
      url          = "https://${fqdn}";
      passwordFile = config.secrets.nextcloudExporterPassword.path;
    };

    scrapeConfigs = [{
      job_name = "nextcloud";

      static_configs = [{
        labels.job = "nextcloud";
        targets    = [
          "[::1]:${toString prometheusPort}"
        ];
      }];
    }];
  };

  services.postgresql = {
    ensureDatabases = [ "nextcloud" ];
    ensureUsers     = [{
      name              = "nextcloud";
      ensureDBOwnership = true;
    }];
  };

  systemd.services.nextcloud-setup = {
    after    = [ "postgresql.service" ];
    requires = [ "postgresql.service" ];

    script = mkAfter ''
      nextcloud-occ theming:config name "RGBCube's Depot"
      nextcloud-occ theming:config slogan "RGBCube's storage of insignificant data."

      nextcloud-occ theming:config color "#000000"
      nextcloud-occ theming:config background backgroundColor

      nextcloud-occ theming:config logo ${./icon.gif}
    '';
  };

  services.nextcloud = enabled {
    package  = nextcloudPackage;

    hostName = fqdn;
    https    = true;

    configureRedis = true;

    config.adminuser     = "admin";
    config.adminpassFile = config.secrets.nextcloudPassword.path;

    config.dbhost = "/run/postgresql";
    config.dbtype = "pgsql";

    settings = {
      default_phone_region = "TR";

      mail_smtphost     = "::1";
      mail_smtpmode     = "sendmail";
      mail_from_address = "cloud";
    };

    settings.enabledPreviewProviders = [
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

    phpOptions = {
      "opcache.interned_strings_buffer" = "16";
      output_buffering                  = "off";
    };

    extraAppsEnable = true;
    extraApps       = {
      inherit (nextcloudPackage.packages.apps)
        bookmarks calendar contacts deck
        forms groupfolders impersonate mail
        maps notes polls previewgenerator tasks;
        # Add: files_markdown files_texteditor memories news
    };

    nginx.recommendedHttpHeaders = true;
  };

  services.nginx.virtualHosts.${fqdn} = config.sslTemplate;
}
