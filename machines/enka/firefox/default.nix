{ homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  programs.firefox = enabled {};
}
