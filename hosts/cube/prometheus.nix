{ config, ulib, ... }: with ulib;

serverSystemConfiguration {
  services.prometheus = enabled {
    port = 9000;

    exporters.node = enabled {
      enabledCollectors = [ "systemd" ];
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
