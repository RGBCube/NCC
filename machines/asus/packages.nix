{ pkgs, packages, ... }:

with pkgs; packages [
  bat
  htop
  neofetch
  wine

  jetbrains.idea-ultimate
  qbittorrent

  libreoffice
  hunspellDicts.en_US
  hunspellDicts.en_GB-ize

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

  lightly-qt
]
