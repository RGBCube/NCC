{ systemConfiguration, enabled, ... }:

systemConfiguration {
  networking = {
    wireless.iwd = enabled {};
    networkmanager = enabled {
      wifi.backend = "iwd";
    };
  };
}
