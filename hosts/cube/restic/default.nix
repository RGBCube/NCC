{ config, lib, ... }: with lib;

systemConfiguration {
  secrets.resticPassword.file = ./password.age;

  services.restic.backups.varlib = {
    passwordFile = config.secrets.resticPassword.path;
    initialize   = true;

    repository = "sftp:backup@disk:cube-varlib";

    paths = [ "/var/lib" ];

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}
