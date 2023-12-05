{ systemConfiguration, enabled, ... }:

systemConfiguration {
  networking.networkmanager = enabled {};

  users.extraGroups.networkmanager.members = [ "nixos" ];
}
