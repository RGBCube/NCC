{ lib, pkgs, upkgs, systemConfiguration, homeConfiguration, enabled, ... }: lib.recursiveUpdate

(systemConfiguration {
  programs.dconf = enabled {};
})

(homeConfiguration "nixos" {
  gtk = enabled {
    font = with upkgs.theme.font; {
      inherit (sans) name package;

      size = size.normal;
    };

    iconTheme = {
      name    = "Gruvbox-Dark";
      package = pkgs.gruvbox-dark-icons-gtk;
    };

    theme = {
      name    = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  xdg.configFile = {
    "gtk-3.0/gtk.css".text = upkgs.theme.adwaitaGtkCss;
    "gtk-4.0/gtk.css".text = upkgs.theme.adwaitaGtkCss;
  };
})

