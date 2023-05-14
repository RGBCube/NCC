{ pkgs, systemPackages, homePackages, ... }:

(with pkgs; systemPackages [
  bat
  htop
  neofetch
  thefuck
  wine

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
])

//

(with pkgs; homePackages "nixos" [
  jetbrains.idea-ultimate
  obs-studio
  qbittorrent

  libreoffice
  hunspellDicts.en_US
  hunspellDicts.en_GB-ize
])
