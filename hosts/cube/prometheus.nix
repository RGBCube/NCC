{ ulib, ... }: with ulib;

serverSystemConfiguration {
  services.prometheus = enabled {
    exporters.node = enabled {
      enabledCollectors = [ "systemd" ];
    };
  };
}
