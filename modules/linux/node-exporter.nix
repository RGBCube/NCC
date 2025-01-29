{ config, lib, ... }: let
  inherit (lib) enabled merge mkIf;
in merge <| mkIf config.isServer {
  services.prometheus.exporters.node = enabled {
    enabledCollectors = [ "processes" "systemd" ];
    listenAddress     = "[::]";
  };
}

