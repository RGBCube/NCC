{ systemConfiguration, homeConfiguration, imports, ... }:

(systemConfiguration {
  system.stateVersion = "22.11";
})

//

(homeConfiguration "nixos" {
  home.stateVersion = "22.11";
})

//

(imports [
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
  ./user.nix
])
