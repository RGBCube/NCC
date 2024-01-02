{ ulib, pkgs, ... }: with ulib;

desktopHomeConfiguration {
  qt = enabled {
    platformTheme = "gnome";
    style.name    = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };
}
