{ pkgs, packages, ... }:

with pkgs; packages [
  bat
  htop
  neofetch

  lightly-qt

  gcc
  go

  (fenix.complete.withComponents [
    "rustc"
    "rust-src"
    "cargo"
    "rustfmt"
    "clippy"
  ])

  (python311.withPackages (pkgs: with pkgs; [
    pip
    requests
  ]))
  virtualenv
  poetry
]
