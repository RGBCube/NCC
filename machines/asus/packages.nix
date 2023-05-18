{ pkgs, systemPackages, homePackages, ... }:

(with pkgs; systemPackages [
  bat
  htop
  neofetch
  thefuck
  wine

  go
  llvmPackages_16.clang-unwrapped
  maven
  temurin-bin-18
  zig

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
  kazam
  krita
  obs-studio
  qbittorrent
  vscode-fhs

  libreoffice
  hunspellDicts.en_US
  hunspellDicts.en_GB-ize
])
