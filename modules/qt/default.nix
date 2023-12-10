{ ulib, pkgs, ... }: with ulib;

graphicalConfiguration {
  qt = enabled {
    platformTheme = "gnome";
    style.name    = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };
}
