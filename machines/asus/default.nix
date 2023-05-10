{ systemConfiguration, homeConfiguration, imports, ... }:

(imports [
  ./discord
  ./docker
  ./firefox
  ./git
  ./intellij
  ./libreoffice
  ./neovim
  ./networkmanager
  ./nushell
  ./openttd
  ./pipewire
  ./qbittorrent
  ./wine
  ./xserver

  ./fonts.nix
  ./hardware.nix
  ./localisation.nix
  ./packages.nix
  ./user.nix
])

//

(systemConfiguration {
  system.stateVersion = "22.11";
})

//

(homeConfiguration "nixos" {
  home.stateVersion = "22.11";
})
