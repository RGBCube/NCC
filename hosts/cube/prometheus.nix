{ ulib, ... }: with ulib;

serverSystemConfiguration {
  services.prometheus = enabled {
    port = 9000;

    exporters.node = enabled {
      enabledCollectors = [ "systemd" ];
      port              = 9001;
    };
  };
}
