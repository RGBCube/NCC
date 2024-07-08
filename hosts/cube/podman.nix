{ lib, ... }: with lib;

systemConfiguration {
  virtualisation.podman = enabled {
    dockerCompat = true;
    dockerSocket = enabled;

    defaultNetwork.settings.dns_enabled = true;

    autoPrune = enabled {
      dates = "weekly";
      flags = [ "--all" ];
    };
  };
}
