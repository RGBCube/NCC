{ lib, ... }: with lib;

desktopUserHomeConfiguration {
  qt = enabled {
    platformTheme.name = "adwaita";
    style.name         = "adwaita";
  };
}
