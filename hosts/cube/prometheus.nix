{ self, config, lib, ... }: with lib;

systemConfiguration {
  services.grafana.provision.datasources.settings = {
    datasources = [{
      name = "Prometheus";
      type = "prometheus";
      url  = "http://[::1]:${toString config.services.prometheus.port}";

      orgId = 1;
    }];

    deleteDatasources = [{
      name  = "Prometheus";
      orgId = 1;
    }];
  };

  services.prometheus = enabled {
    listenAddress = "[::]";
    retentionTime = "1w";

    scrapeConfigs = with lib; let
      configToScrapeConfig = name: { config, ... }: pipe config.services.prometheus.exporters [
        (filterAttrs (const (value: value.enable or false)))
        (mapAttrsToList (expName: expConfig: {
          job_name = "${expName}-${name}";

          static_configs = [{
            targets = [ "${name}:${toString expConfig.port}" ];
          }];
        }))
      ];
    in flatten (mapAttrsToList configToScrapeConfig self.nixosConfigurations);
  };
}
