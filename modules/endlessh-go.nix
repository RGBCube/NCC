{ config, ulib, pkgs, ... }: with ulib;

serverSystemConfiguration {
  services.prometheus.scrapeConfigs = [{
    job_name = "endlessh-go";

    static_configs = [{
      labels.job = "endlessh-go";
      targets    = [
        "[::]:${toString config.services.endlessh-go.prometheus.port}"
      ];
    }];
  }];

  nixpkgs.config.allowUnfree = true; # For pkgs.clash-geoip.

  # services.endlessh-go.openFirewall exposes both the Prometheus
  # exporters port and the SSH port, and we don't want the metrics
  # to leak, so we manually expose this like so.
  networking.firewall.allowedTCPPorts = [ config.services.endlessh-go.port ];

  services.endlessh-go = enabled {
    port = 22;

    extraOptions = [
      "-alsologtostderr"
      "-geoip_supplier max-mind-db"
      "-max_mind_db ${pkgs.clash-geoip}/etc/clash/Country.mmdb"
    ];

    prometheus = enabled {
      listenAddress = "[::]";
      port          = 9050;
    };
  };
}
