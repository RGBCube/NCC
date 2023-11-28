{ homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  programs.eww = enabled {
    configDir = ./.;
  };
}
