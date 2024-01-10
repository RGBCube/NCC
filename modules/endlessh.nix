{ ulib, ... }: with ulib;

serverSystemConfiguration {
  services.endlessh = enabled {
    openFirewall = true;
    port         = 22;
  };
}
