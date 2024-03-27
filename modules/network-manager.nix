{ lib, ... }: with lib;

systemConfiguration {
  networking.networkmanager = enabled;

  users.extraGroups.networkmanager.members = allNormalUsers;

  environment.shellAliases.wifi = "nmcli dev wifi show-password";
}
