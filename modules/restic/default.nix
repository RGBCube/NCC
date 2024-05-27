{ config, lib, ... }: with lib;

serverSystemConfiguration {
  options.resticHosts = mkConst (remove config.networking.hostName [ "cube" "disk" "nine" ]);

  config = {
    secrets.resticPassword.file = ./password.age;

    services.restic.backups = genAttrs config.resticHosts (host: {
      repository   = "sftp:backup@${host}:${config.networking.hostName}-backup";
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
    });
  };
}
