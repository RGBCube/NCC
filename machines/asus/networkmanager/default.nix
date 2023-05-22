{ systemConfiguration, enabled, ... }:

systemConfiguration {
  networking.networkmanager = enabled {};
}
