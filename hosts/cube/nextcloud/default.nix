 { config, lib, pkgs, ... }: let
  inherit (config.networking) domain;
  inherit (lib) const enabled genAttrs mkAfter;

  fqdn = "cloud.${domain}";

  packageNextcloud = pkgs.nextcloud29;
in {
  secrets.nextcloudPassword = {
    file  = ./password.age;
    owner = "nextcloud";
  };
  secrets.nextcloudPasswordExporter = {
    file  = ./password.age;
    owner = "nextcloud-exporter";
  };

  services.prometheus.exporters.nextcloud = enabled {
    listenAddress = "[::]";

    username     = "admin";
    url          = "https://${fqdn}";
    passwordFile = config.secrets.nextcloudPasswordExporter.path;
  };

  services.postgresql = let
    users = [ "nextcloud" ];
  in {
    ensureDatabases = users;
    ensureUsers     = map users (name: {
      inherit name;

      ensureDBOwnership = true;
    });
  };

  services.restic.backups = genAttrs config.services.restic.hosts <| const {
    paths = [ "/var/lib/nextcloud" ];
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
    package  = packageNextcloud;

    hostName = fqdn;
    https    = true;

    configureRedis = true;

    config.adminuser     = "admin";
    config.adminpassFile = config.secrets.nextcloudPassword.path;

    config.dbhost = "/run/postgresql";
    config.dbtype = "pgsql";

    settings = {
      default_phone_region = "TR";

      # Even with manual SMTP configuration, Nextcloud fails to communicate properly
      # and fails to send mail. PHP moment?
      # mail_smtphost     = "::1"; # FIXME: Will need to use SMTP.
      # mail_smtpmode     = "sendmail";
      # mail_from_address = "cloud";

      maintenance_window_start = 1;

      # No clue why it was syslog.
      # What are the NixOS module authors on?
      log_type = "file";
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
      inherit (packageNextcloud.packages.apps)
        bookmarks calendar contacts deck
        forms impersonate mail # groupfolders impersonate mail
        maps notes polls previewgenerator; # tasks;
        # Add: files_markdown files_texteditor memories news
    };

    nginx.recommendedHttpHeaders = true;
  };

  services.nginx.virtualHosts.${fqdn} = config.ngnixSslTemplate;
}
