{ ulib, ... }: with ulib;

serverSystemConfiguration {
  virtualisation.podman = enabled {
    dockerCompat = true;
    dockerSocket = enabled {};

    defaultNetwork.settings.dns_enabled = true;

    autoPrune = enabled {
      dates = "daily";
      flags = [ "--all" ];
    };
  };
}
