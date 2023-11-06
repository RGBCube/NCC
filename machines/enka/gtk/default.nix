{ lib, pkgs, systemConfiguration, homeConfiguration, enabled, ... }: lib.recursiveUpdate

(systemConfiguration {
  programs.dconf = enabled {};
})

(homeConfiguration "nixos" {
  gtk = enabled {
    cursorTheme = {
      name    = "Gruvbox";
      package = pkgs.capitaine-cursors-themed;
    };

    font = {
      name    = "JetBrainsMono";
      package = pkgs.jetbrains-mono;
      size    = 11;
    };

    iconTheme = {
      name    = "gruvbox-dark";
      package = pkgs.gruvbox-dark-icons-gtk;
    };

    theme = {
      name    = "Gruvbox-Dark-BL";
      package = pkgs.gruvbox-gtk-theme;
    };
  };
})

