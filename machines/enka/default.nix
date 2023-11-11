{ lib, systemConfiguration, homeConfiguration, imports, ... }: lib.recursiveUpdate3

(systemConfiguration {
  system.stateVersion = "23.05";
})

(homeConfiguration "nixos" {
  home.stateVersion = "23.05";
})

(imports [
  ./bat
  ./blueman
  ./discord
  ./docker
  ./dunst
  ./firefox
  ./fuzzel
  ./git
  ./gtk
  ./helix
  ./hyprland
  ./kitty
  ./networkmanager
  ./nushell
  ./openttd
  ./pipewire
  ./python
  ./steam
  ./steck

  ./fonts.nix
  ./hardware.nix
  ./localisation.nix
  ./packages.nix
  ./users.nix
])
