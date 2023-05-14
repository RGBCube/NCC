{ pkgs, packages, ... }:

with pkgs; packages [
  bat
  htop
  neofetch
  thefuck
  wine

  jetbrains.idea-ultimate
  obs-studio
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

  lightly-qt
]
