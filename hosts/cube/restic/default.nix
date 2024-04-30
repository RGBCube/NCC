{ config, lib, ... }: with lib;

systemConfiguration {
  secrets.resticPassword.file = ./password.age;

  services.restic.backups.general = {
    passwordFile = config.secrets.resticPassword.path;
    initialize   = true;

    repository = "sftp:backup@disk:${config.networking.hostName}-varlib";

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

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}
