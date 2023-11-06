{ lib, pkgs, systemPackages, homeConfiguration, ... }: lib.recursiveUpdate

(with pkgs; systemPackages [
  steck
])

(homeConfiguration "nixos" {
  programs.nushell.shellAliases.share = "steck paste";
})
