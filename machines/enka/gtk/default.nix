{ lib, pkgs, theme, systemConfiguration, homeConfiguration, enabled, ... }: lib.recursiveUpdate

(systemConfiguration {
  programs.dconf = enabled {};
})

(homeConfiguration "nixos" {
  gtk = enabled {
    gtk3.extraCss = theme.adwaitaGtkCss;
    gtk4.extraCss = theme.adwaitaGtkCss;

    font = with theme.font; {
      inherit (sans) name package;

      size = size.normal;
    };

    iconTheme = theme.icons;

    theme = {
      name    = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
})

