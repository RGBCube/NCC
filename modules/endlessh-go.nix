{ lib, pkgs, ... }: with lib;

let
  fakeSSHPort    = 22;
in serverSystemConfiguration {
  services.prometheus.exporters.endlessh-go = enabled {
    listenAddress = "[::]";
  };

  # `services.endlessh-go.openFirewall` exposes both the Prometheus
  # exporters port and the SSH port, and we don't want the metrics
  # to leak, so we manually expose this like so.
  networking.firewall.allowedTCPPorts = [ fakeSSHPort ];

  services.endlessh-go = enabled {
    listenAddress = "[::]";
    port          = fakeSSHPort;

    extraOptions = [
      "-alsologtostderr"
      "-geoip_supplier max-mind-db"
      "-max_mind_db ${pkgs.clash-geoip}/etc/clash/Country.mmdb"
    ];
  };
}
