{ config, lib, pkgs, ... }: with lib;

systemConfiguration {
  secrets.resticPassword.file = ./password.age;

  services.restic.backups.disk = {
    repository   = "sftp:backup@disk:${config.networking.hostName}-backup";
    passwordFile = config.secrets.resticPassword.path;
    initialize   = true;

    pruneOpts = [
      "--keep-daily unlimited"
      "--keep-weekly unlimited"
      "--keep-monthly 6"
      "--keep-yearly 12"
    ];

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };

    paths = [
      "/tmp/postgresql-dump.sql.gz"
    ] ++ map (dir: "/var/lib/${dir}") [
      "forgejo"
      "gitea-runner"
      "grafana"
      "matrix-sliding-sync"
      "matrix-synapse"
      "nextcloud"
    ];

    backupPrepareCommand = ''
      ${config.services.postgresql.package}/bin/pg_dumpall --clean \
      | ${lib.getExe pkgs.gzip} --rsyncable \
      > /tmp/postgresql-dump.sql.gz
    '';

    backupCleanupCommand = ''
      rm /tmp/postgresql-dump.sql.gz
    '';
  };
}
