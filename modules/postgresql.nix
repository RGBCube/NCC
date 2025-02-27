{ config, lib, pkgs, ... }: let
  inherit (lib) const enabled flip genAttrs mkForce mkOverride mkValue;
in {
  config.services.prometheus.exporters.postgres = enabled {
    listenAddress       = "[::]";
    runAsLocalSuperUser = true;
  };

  config.services.restic.backups = genAttrs config.services.restic.hosts <| const {
    paths = [ "/tmp/postgresql-dump.sql.gz" ];

    backupPrepareCommand = /* sh */ ''
      ${config.services.postgresql.package}/bin/pg_dumpall --clean \
      | ${lib.getExe pkgs.gzip} --rsyncable \
      > /tmp/postgresql-dump.sql.gz
    '';

    backupCleanupCommand = /* sh */ ''
      rm /tmp/postgresql-dump.sql.gz
    '';
  };

  config.environment.systemPackages = [
    config.services.postgresql.package
  ];

  options.services.postgresql.ensure = mkValue [];

  config.services.postgresql = enabled {
    package = pkgs.postgresql_17;

    enableJIT   = true;
    enableTCPIP = true; # We override it, but might as well.

    settings.listen_addresses = mkForce "::";
    authentication            = mkOverride 10 /* ini */ ''
      #     DATABASE USER        AUTHENTICATION
      local all      all         peer

      #     DATABASE USER ADDRESS AUTHENTICATION
      host  all      all  ::/0    md5
    '';

    ensure = [ "postgres" "root" ];

    initdbArgs      = [ "--locale=C" "--encoding=UTF8" ];
    ensureDatabases = config.services.postgresql.ensure;

    ensureUsers = flip map config.services.postgresql.ensure (name: {
      inherit name;

      ensureDBOwnership = true;

      ensureClauses = {
        login       = true;
        superuser   = name == "postgres" || name == "root";
      };
    });
  };
}

