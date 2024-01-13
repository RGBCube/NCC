{ config, ulib, ... }: with ulib;

serverSystemConfiguration {
  services.grafana.provision.datasources.settings.datasources = [{
    name = "Prometheus";
    type = "prometheus";
    url  = "http://[::]:${toString config.services.prometheus.port}";
  }];

  services.prometheus = enabled {
    port = 9000;

    exporters.node = enabled {
      enabledCollectors = [ "processes" "systemd" ];
      port              = 9001;
    };

    scrapeConfigs = [{
      job_name = "node";

      static_configs = [{
        labels.job = "node";
        targets    = [ "[::]:${toString config.services.prometheus.exporters.node.port}" ];
      }];
    }];
  };
}
