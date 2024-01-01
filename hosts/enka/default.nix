{ ulib, ... }: with ulib; merge3

(systemConfiguration {
  system.stateVersion = "23.05";

  console.keyMap = "trq";
  time.timeZone = "Europe/Istanbul";

  users.users.nixos = normalUser {
    description = "NixOS";
    extraGroups = [ "wheel" ];
  };

  networking.firewall = enabled {
    allowedTCPPorts = [ 8080 ];
  };
})

(homeConfiguration {
  home.stateVersion = "23.05";
})

(importModules [
  ./hardware.nix

  "autofreq"
  "bat"
  "blueman"
  "boot"
  "btop"
  "discord"
  "dunst"
  "firefox"
  "fonts"
  "fuzzel"
  "ghostty"
  "git"
  "gtk"
  "helix"
  "hyprland"
  "kernel"
  "kitty"
  "localisation"
  "logind"
  "networkmanager"
  "nix"
  "nushell"
  "openttd"
  "packages"
  "pipewire"
  "pueue"
  "python"
  "qt"
  "ripgrep"
  "rust"
  "ssh"
  "steam"
  "sudo"
  "tmp"
  "w3m"
  "waybar"
])
