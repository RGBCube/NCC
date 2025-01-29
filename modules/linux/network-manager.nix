{ config, lib, ... }: let
  inherit (lib) attrNames const enabled filterAttrs getAttr;
in {
  networking.networkmanager = enabled;

  users.extraGroups.networkmanager.members = config.users.users
    |> filterAttrs (const <| getAttr "isNormalUser")
    |> attrNames;

  environment.shellAliases.wifi = "nmcli dev wifi show-password";
}

