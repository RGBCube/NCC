{ pkgs, homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  qt = enabled {
    style.name    = "Adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };
}
