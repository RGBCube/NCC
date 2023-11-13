{ lib, pkgs, systemPackages, homeConfiguration, ... }: lib.recursiveUpdate

(with pkgs; systemPackages [
  steck
])

(homeConfiguration [ "nixos" "root" ] {
  programs.nushell.shellAliases.share = "steck paste";
})
