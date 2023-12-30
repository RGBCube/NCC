{ ulib, pkgs, ... }: with ulib;

systemPackages (with pkgs; [
  fastfetch
  fd
  hyperfine
  moreutils
  nix-index
  nix-output-monitor
  p7zip
  pstree
  strace
  tree
  yt-dlp

  gh
])
