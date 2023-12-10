{ ulib, pkgs, ... }: with ulib; merge

(systemPackages (with pkgs; [
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
]))

<<<<<<< Updated upstream:enka/packages.nix
])

(with pkgs; graphicalPackages [
  jetbrains.idea-ultimate

=======
(graphicalPackages (with pkgs; [
>>>>>>> Stashed changes:modules/packages/default.nix
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
