# And yes, I've tried lib.mkAliasOptionModule.
# It doesn't work for a mysterious reason,
# says it can't find `services.prometheus.exporters.endlessh-go`.
#
# This works, however.

{ config, lib, ... }: {
  options.services.prometheus.exporters.endlessh-go = lib.mkOption {
    default = {};
  };

  config.services.endlessh-go.prometheus = config.services.prometheus.exporters.endlessh-go;
}
