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
    "cargo"
    "clippy"
    "rust-src"
    "rustc"
    "rustfmt"
  ])

  lightly-qt
])

(with pkgs; homePackages "nixos" [
  graphviz
  heroic
  jetbrains.idea-ultimate
  kazam
  krita
  obs-studio
  qbittorrent
  thunderbird
  vscode-fhs

  libreoffice
  hunspellDicts.en_US
  hunspellDicts.en_GB-ize
])
