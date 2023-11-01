{ lib, pkgs, systemConfiguration, systemPackages, enabled, ... }: lib.recursiveUpdate

(systemConfiguration {
  networking.networkmanager = enabled {};
})

(with pkgs; systemPackages [
  nmcli
  nmtui
])

