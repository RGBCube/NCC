{ config, lib, ulib, ... }: with ulib;

serverSystemConfiguration {
  services.prometheus.exporters.postgres = enabled {
    port                = 9030;
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
  };
}
