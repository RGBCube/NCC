{ lib, systemConfiguration, homeConfiguration, imports, ... }: lib.recursiveUpdate3

(systemConfiguration {
  system.stateVersion = "23.05";
})

(homeConfiguration "nixos" {
  home.stateVersion = "23.05";
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
  ./steam
  ./xserver

  ./fonts.nix
  ./hardware.nix
  ./localisation.nix
  ./packages.nix
  ./users.nix
])
