{ systemConfiguration, enabled, ... }:

systemConfiguration {
  networking.networkmanager = enabled {};
  systemd.network = enabled {};
}
