{ lib, pkgs, systemPackages, homePackages, ... }: lib.recursiveUpdate

(with pkgs; systemPackages [
  fd
  fzf
  htop
  jq
  neofetch
  ripgrep
  thefuck
  tree

  wine

  gcc
  go
  jdk
  maven
  vlang
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

(with pkgs; homePackages "nixos" [
  heroic
  jetbrains.idea-ultimate
  kazam
  krita
  obs-studio
  qbittorrent
  steam
  thunderbird
  vscode-fhs

  libreoffice
  hunspellDicts.en_US
  hunspellDicts.en_GB-ize
])
