{ pkgs, systemPackages, ... }:

with pkgs; systemPackages [
  (python311.withPackages (pkgs: with pkgs; [
    pip
    requests
  ]))
  virtualenv
  poetry
]
