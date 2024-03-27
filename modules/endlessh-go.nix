{ lib, pkgs, ... }: with lib;

let
  fakeSSHPort    = 22;
  prometheusPort = 9050;
in serverSystemConfiguration {
  services.prometheus.scrapeConfigs = [{
    job_name = "endlessh-go";

    static_configs = [{
      labels.job = "endlessh-go";
      targets    = [
        "[::1]:${toString prometheusPort}"
      ];
    }];
  }];

  nixpkgs.config.allowUnfree = true; # For pkgs.clash-geoip.

  # services.endlessh-go.openFirewall exposes both the Prometheus
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

    prometheus = enabled {
      listenAddress = "[::1]";
      port          = prometheusPort;
    };
  };
}
