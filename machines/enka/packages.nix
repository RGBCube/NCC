{ lib, pkgs, systemPackages, homePackages, ... }: lib.recursiveUpdate

(with pkgs; systemPackages [
  fastfetch
  fd
  gotop
  hyperfine
  nix-output-monitor
  ripgrep
  strace
  tree

  wine

  clang_16
  clang-tools_16
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
