{ lib, pkgs, systemPackages, homePackages, ... }: lib.recursiveUpdate

(with pkgs; systemPackages [
  fastfetch
  fd
  gotop
  hyperfine
  nix-index
  nix-output-monitor
  pstree
  ripgrep
  strace
  tree

  wine

  clang_16
  clang-tools_16
  gh
  go
  jdk
  lld
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
])

(with pkgs; homePackages "nixos" [
  jetbrains.idea-ultimate

  qbittorrent
  thunderbird
  whatsapp-for-linux

  krita
  obs-studio

  libreoffice
  hunspellDicts.en_US
  hunspellDicts.en_GB-ize
])
