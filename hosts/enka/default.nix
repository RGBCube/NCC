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
  ./hardware.nix

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
  "kitty"
  # "kmscon"
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
  "steck"
  "sudo"
  "waybar"
])
