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
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 12"
      ];
    });
  };
}
