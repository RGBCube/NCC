{ config, lib, ulib, pkgs, ... }: with ulib; merge

(serverSystemConfiguration {
  services.prometheus.exporters.postgres = enabled {
    port                = 9040;
    runAsLocalSuperUser = true;
  };

  services.prometheus.scrapeConfigs = [{
    job_name = "postgres";

    static_configs = [{
      labels.job = "postgres";
      targets    = [ "[::]:${toString config.services.prometheus.exporters.postgres.port}" ];
    }];
  }];

  services.postgresql = enabled {
    enableTCPIP    = true;

    authentication = lib.mkOverride 10 ''
    # Type  Database DBUser Authentication IdentMap
      local sameuser all    peer           map=superuser_map
    '';

    identMap = ''
    # Map           System   DBUser
      superuser_map root     postgres
      superuser_map postgres postgres
      superuser_map /^(.*)$  \1
    '';

    ensureDatabases = [ "grafana" "nextcloud" ];

    initialScript   = pkgs.writeText "postgresql-initial-script" ''
      CREATE ROLE root WITH LOGIN PASSWORD NULL CREATEDB;

      CREATE ROLE grafana WITH LOGIN PASSWORD NULL CREATEDB;
      GRANT ALL PRIVILEGES ON DATABASE grafana TO grafana;

      CREATE ROLE nextcloud WITH LOGIN PASSWORD NULL CREATEDB;
      GRANT ALL PRIVILEGES ON DATABASE nextcloud TO nextcloud;
    '';
  };
})

(serverSystemPackages (with pkgs; [
  postgresql
]))
