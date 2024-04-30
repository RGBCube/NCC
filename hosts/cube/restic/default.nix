{ config, lib, pkgs, ... }: with lib;

systemConfiguration {
  secrets.resticPassword.file = ./password.age;

  services.restic.backups = let
    defaultConfig = name: {
      repository   = "sftp:backup@disk:${config.networking.hostName}-${name}";
      passwordFile = config.secrets.resticPassword.path;
      initialize   = true;

      pruneOpts = [
        "--keep-daily 3"
        "--keep-weekly 5"
        "--keep-monthly 12"
        "--keep-yearly 75"
      ];

      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };
  in {
    general = (defaultConfig "general") // {
      paths = map (dir: "/var/lib/${dir}") [
        "dkim"
        "forgejo"
        "gitea-runner"
        "grafana"
        "mail"
        "matrix-sliding-sync"
        "matrix-synapse"
        "nextcloud"
        "postfix"
      ];
    };

    postgresql = (defaultConfig "postgresql") // {
      paths = [ "/tmp/postgresql-dump.sql.gz" ];

      backupPrepareCommand = ''
        ${config.services.postgresql.package}/bin/pg_dumpall --clean \
        | ${lib.getExe pkgs.gzip} --rsyncable \
        > /tmp/postgresql-dump.sql.gz
      '';

      backupCleanupCommand = ''
        rm /tmp/postgresql-dump.sql.gz
      '';
    };
  };
}
