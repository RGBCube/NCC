{ lib, pkgs, upkgs, systemConfiguration, homeConfiguration, enabled, ... }: lib.recursiveUpdate

(systemConfiguration {
  programs.dconf = enabled {};
})

(homeConfiguration "nixos" {
  gtk = enabled {
    font = {
      name    = "OpenSans";
      package = pkgs.open-sans;
      size    = 12;
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

