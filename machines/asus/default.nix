{ lib, systemConfiguration, homeConfiguration, imports, ... }: lib.recursiveUpdate3

(systemConfiguration {
  system.stateVersion = "22.11";
})

(homeConfiguration "nixos" {
  home.stateVersion = "22.11";
})

(imports [
  ./bat
  ./discord
  ./docker
  ./firefox
  ./git
  ./helix
  ./networkmanager
  ./nushell
  ./openttd
  ./pipewire
  ./python
  ./xserver

  ./fonts.nix
  ./hardware.nix
  ./localisation.nix
  ./packages.nix
  ./users.nix
])
