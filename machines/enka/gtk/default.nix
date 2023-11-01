{ pkgs, homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  gtk = enabled {
    cursorTheme = {
      package = pkgs.capitaine-cursors-themed;
      name    = "Gruvbox";
    };

    font = {
      package = pkgs.jetbrains-mono;
      name    = "JetBrainsMono";
      size    = 11;
    };

    iconTheme = {
      package = pkgs.gruvbox-dark-icons-gtk;
      name    = "gruvbox-dark";
    };

    theme = {
      package = pkgs.gruvbox-gtk-theme;
      name    = "Gruvbox-Dark-BL";
    };
  };
}

