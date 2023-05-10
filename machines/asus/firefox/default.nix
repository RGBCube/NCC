{ systemConfiguration, enabled, ... }:

systemConfiguration {
  programs.firefox = enabled {};
}
