{ pkgs, ulib, systemConfiguration, homeConfiguration, imports, ... }: ulib.recursiveUpdate3

(systemConfiguration {
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader         = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable      = true;
    systemd-boot.editor      = false;
  };

  system.stateVersion = "23.05";
})

(homeConfiguration [ "nixos" "root" ] {
  home.stateVersion = "23.05";
})

(imports [
  ./bat
  ./blueman
  ./discord
  ./dunst
  ./firefox
  ./fuzzel
  ./ghostty
  ./git
  ./greetd
  ./gtk
  ./helix
  ./hyprland
  ./kitty
  ./logind
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
