{ config, lib, ... }: let
  inherit (lib) genAttrs merge mkConst mkIf remove;
in{
  options.resticHosts = mkConst <| remove config.networking.hostName [ "cube" "disk" "nine" ];

  config.secrets.resticPassword.file = mkIf config.isServer ./password.age;

  config.services.restic.backups =  mkIf config.isServer <| genAttrs config.resticHosts (host: {
    repository   = "sftp:backup@${host}:${config.networking.hostName}-backup";
    passwordFile = config.secrets.resticPassword.path;
    initialize   = true;

    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 12"
    ];
  });
}

