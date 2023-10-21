{ systemConfiguration, normalUser, ... }:

systemConfiguration {
  users.users.nixos = normalUser {
    description = "NixOS";

    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
  };
}
