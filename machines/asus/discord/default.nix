{ pkgs, homePackages, ... }:

with pkgs; homePackages "nixos" [
  (discord.override {
    withOpenASAR = true;
    withVencord  = true;
  })
]
