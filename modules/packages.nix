{ ulib, pkgs, upkgs, ... }: with ulib; merge3

(systemPackages (with pkgs; [
  asciinema
  curlHTTP3
  dig
  fastfetch
  fd
  hyperfine
  moreutils
  nix-index
  nix-output-monitor
  openssl
  p7zip
  pstree
  strace
  timg
  tree
  usbutils
  yazi
  yt-dlp
]))

(desktopSystemPackages (with pkgs; [
  upkgs.agenix

  clang_16
  clang-tools_16
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
  element-desktop-wayland
  qbittorrent
  thunderbird
  whatsapp-for-linux
  xfce.thunar

  krita
  obs-studio

  libreoffice
  hunspellDicts.en_US
  hunspellDicts.en_GB-ize
]))
