{ config, lib, pkgs, ... }: let
  inherit (lib) enabled merge mkEnableOption mkIf mkOption types;

  fakeSSHPort    = 22;
in {
  config.services.prometheus.exporters.endlessh-go = mkIf config.isServer <| enabled {
    listenAddress = "[::]";
  };

  # `services.endlessh-go.openFirewall` exposes both the Prometheus
  # exporters port and the SSH port, and we don't want the metrics
  # to leak, so we manually expose this like so.
  config.networking.firewall.allowedTCPPorts = mkIf config.isServer <| [ fakeSSHPort ];

  config.services.endlessh-go = mkIf config.isServer <| enabled {
    listenAddress = "[::]";
    port          = fakeSSHPort;

    extraOptions = [
      "-alsologtostderr"
      "-geoip_supplier max-mind-db"
      "-max_mind_db ${pkgs.clash-geoip}/etc/clash/Country.mmdb"
    ];

    prometheus = config.services.prometheus.exporters.endlessh-go;
  };

  # And yes, I've tried lib.mkAliasOptionModule.
  # It doesn't work for a mysterious reason,
  # says it can't find `services.prometheus.exporters.endlessh-go`.
  #
  # This works, however.
  #
  # TODO: I may be stupid, because the above note says that I tried
  # to alias to a nonexistent option, rather than the other way around.
  # Let's try mkAliasOptionModule again later.
  options.services.prometheus.exporters.endlessh-go = {
    enable = mkEnableOption "Prometheus integration";

    listenAddress = mkOption {
      type = types.str;
      default = "0.0.0.0";
    };

    port = mkOption {
      type = types.port;
      default = 2112;
    };
  };
}
