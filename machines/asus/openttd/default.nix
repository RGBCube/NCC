{ pkgs, homePackages, ... }:

with pkgs; homePackages "nixos" [
    openttd
]
