{ ulib, pkgs, ... }: with ulib; merge

(systemPackages (with pkgs; [
  asciinema
  fastfetch
  fd
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
  usbutils
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
]))

(graphicalPackages (with pkgs; [
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
