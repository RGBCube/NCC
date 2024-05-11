# And yes, I've tried lib.mkAliasOptionModule.
# It doesn't work for a mysterious reason,
# says it can't find `services.prometheus.exporters.endlessh-go`.
#
# This works, however.

{ config, lib, ... }: {
  options.services.prometheus.exporters.endlessh-go = {
    enable = lib.mkEnableOption (lib.mdDoc "Prometheus integration");

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 2112;
    };
  };

  config.services.endlessh-go.prometheus = config.services.prometheus.exporters.endlessh-go;
}
