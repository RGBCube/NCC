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

  services.endlessh-go = enabled {
    openFirewall = true;
    port         = 22;

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
