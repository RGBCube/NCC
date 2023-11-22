{ homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  programs.firefox = enabled {};

  programs.librewolf = enabled {};
}
