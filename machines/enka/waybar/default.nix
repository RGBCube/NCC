{ homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  programs.waybar = enabled {
    systemd = enabled {};
  };
}
