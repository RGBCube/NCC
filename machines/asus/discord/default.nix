{ pkgs, homePackages, ... }:

with pkgs; homePackages "nixos" [
    discord
]
