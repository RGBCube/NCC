{ lib, pkgs, ... }: with lib; merge

(systemPackages (with pkgs; [
  asciinema
  cowsay
  curlHTTP3
  dig
  doggo
  fastfetch
  fd
  (fortune.override { withOffensive = true; })
  hyperfine
  moreutils
  openssl
  p7zip
  pstree
  rsync
  strace
  timg
  traceroute
  tree
  usbutils
  uutils-coreutils-noprefix
  yazi
  yt-dlp
]))

(desktopSystemPackages (with pkgs; [
  # clang_16
  # clang-tools_16
  deno
  gh
  # go
  # jdk
  lld
  # maven
  # vlang
  # zig

  # wine
]))

(desktopUserHomePackages (with pkgs; [
  element-desktop
  fractal
  # whatsapp-for-linux
  # zulip

  qbittorrent

  thunderbird

  # krita
  obs-studio

  # libreoffice
  # hunspellDicts.en_US
  # hunspellDicts.en_GB-ize
]))
