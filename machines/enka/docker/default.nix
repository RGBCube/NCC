{ systemConfiguration, enabled, ... }:

systemConfiguration {
  virtualisation.docker = enabled {};
}
