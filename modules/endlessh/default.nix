{ ulib, ... }: with ulib;

systemConfiguration {
  services.endlessh = enabled {
    openFirewall = true;
  };
}
