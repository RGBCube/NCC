{ ... }:

{
  users.users.nixos = {
    description = "NixOS";
    isNormalUser = true;

    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
  };
}
