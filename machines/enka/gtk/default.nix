{ lib, pkgs, upkgs, systemConfiguration, homeConfiguration, enabled, ... }: lib.recursiveUpdate

(systemConfiguration {
  programs.dconf = enabled {};
})

(homeConfiguration "nixos" {
  gtk = enabled {
    gtk3.extraCss = upkgs.theme.adwaitaGtkCss;
    gtk4.extraCss = upkgs.theme.adwaitaGtkCss;

    font = with upkgs.theme.font; {
      inherit (sans) name package;

      size = size.normal;
    };

    iconTheme = upkgs.theme.icons;

    theme = {
      name    = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
})

