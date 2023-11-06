{ systemConfiguration, normalUser, ... }:

systemConfiguration {
  users.users.nixos = normalUser {
    description = "NixOS";

    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
    ];
  };
}
