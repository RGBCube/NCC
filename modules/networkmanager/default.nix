{ ulib, ... }: with ulib;

systemConfiguration {
  networking.networkmanager = enabled {};

  users.extraGroups.networkmanager.members = [ "nixos" ];
}
