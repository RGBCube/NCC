{ pkgs, homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  qt = enabled {
    platformTheme = "gnome";
    style.name    = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };
}
