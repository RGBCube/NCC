{ lib, pkgs, systemPackages, homePackages, ... }: lib.recursiveUpdate

(with pkgs; systemPackages [
  asciinema
  fastfetch
  fd
  gotop
  hyperfine
  moreutils
  nix-index
  nix-output-monitor
  p7zip
  pstree
  ripgrep
  strace
  timg
  tree
  yt-dlp

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
  xfce.thunar

  krita
  obs-studio

  libreoffice
  hunspellDicts.en_US
  hunspellDicts.en_GB-ize
])
