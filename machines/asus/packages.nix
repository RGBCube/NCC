{ pkgs, systemPackages, homePackages, ... }:

(with pkgs; systemPackages [
  fd
  fzf
  htop
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

//

(with pkgs; homePackages "nixos" [
  heroic
  jetbrains.idea-ultimate
  kazam
  krita
  obs-studio
  qbittorrent
  steam
  vscode-fhs

  libreoffice
  hunspellDicts.en_US
  hunspellDicts.en_GB-ize
])
