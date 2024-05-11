{ lib, ... }: with lib;

serverSystemConfiguration {
  services.prometheus.exporters.node = enabled {
    enabledCollectors = [ "processes" "systemd" ];
    listenAddress     = "[::]";
  };
}
