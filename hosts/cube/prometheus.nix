{ lib, ... }: with lib;

let
  port = 9000;

  nodeExporterPort = 9010;
in systemConfiguration {
  services.grafana.provision.datasources.settings = {
    datasources = [{
      name = "Prometheus";
      type = "prometheus";
      url  = "http://[::1]:${toString port}";

      orgId = 1;
    }];

    deleteDatasources = [{
      name  = "Prometheus";
      orgId = 1;
    }];
  };

  services.prometheus = enabled {
    inherit port;

    retentionTime = "1w";

    exporters.node = enabled {
      enabledCollectors = [ "processes" "systemd" ];
      listenAddress     = "[::1]";
      port              = nodeExporterPort;
    };

    scrapeConfigs = [{
      job_name = "node";

      static_configs = [{
        labels.job = "node";
        targets    = [ "[::1]:${toString nodeExporterPort}" ];
      }];
    }];
  };
}
