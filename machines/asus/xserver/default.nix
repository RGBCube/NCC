{ systemConfiguration, enabled, ... }:

systemConfiguration {
  services.xserver = enabled {
    displayManager.sddm    = enabled {};
    desktopManager.plasma5 = enabled {};
  };
}
