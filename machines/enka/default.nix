{ lib, systemConfiguration, homeConfiguration, imports, ... }: lib.recursiveUpdate3

(systemConfiguration {
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable      = true;
    systemd-boot.editor      = false;
  };

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
  ./waybar

  ./fonts.nix
  ./localisation.nix
  ./packages.nix
  ./users.nix

  /etc/nixos/hardware-configuration.nix
])
