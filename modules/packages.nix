{ ulib, pkgs, upkgs, ... }: with ulib; merge3

(systemPackages (with pkgs; [
  asciinema
  cowsay
  curlHTTP3
  dig
  fastfetch
  fd
  (fortune.override { withOffensive = true; })
  hyperfine
  moreutils
  nix-index
  nix-output-monitor
  openssl
  p7zip
  pstree
  rsync
  strace
  timg
  tree
  usbutils
  uutils-coreutils-noprefix
  yazi
  yt-dlp
]))

(desktopSystemPackages (with pkgs; [
  upkgs.agenix

  clang_16
  clang-tools_16
  deno
  gh
  go
  jdk
  lld
  maven
  upkgs.zig
  vlang

  wine
]))

(desktopHomePackages (with pkgs; [
  element-desktop
  fractal
  qbittorrent
  thunderbird
  upkgs.rat
  whatsapp-for-linux

  krita
  obs-studio

  libreoffice
  hunspellDicts.en_US
  hunspellDicts.en_GB-ize
]))
