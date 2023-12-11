{ ulib, ... }: with ulib; merge3

(systemConfiguration {
  system.stateVersion = "23.05";

  users.users.nixos = graphicalUser {
    description = "NixOS";
    extraGroups = [ "wheel" ];
  };
})

(homeConfiguration {
  home.stateVersion = "23.05";
})

(importModules [
  "bat"
  "blueman"
  "boot"
  "discord"
  "dunst"
  "firefox"
  "fonts"
  "fuzzel"
  "ghostty"
  "git"
  "greetd"
  "gtk"
  "helix"
  "hyprland"
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
  "rust"
  "steam"
  "steck"
  "waybar"

  /etc/nixos/hardware-configuration.nix
])
