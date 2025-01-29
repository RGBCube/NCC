{ config, lib, pkgs, ... }: let
  inherit (lib) optionals;
in {
  environment.systemPackages = [
    pkgs.asciinema
    pkgs.cowsay
    pkgs.curlHTTP3
    pkgs.dig
    pkgs.doggo
    pkgs.fastfetch
    pkgs.fd
    (pkgs.fortune.override { withOffensive = true; })
    pkgs.hyperfine
    pkgs.moreutils
    pkgs.openssl
    pkgs.p7zip
    pkgs.pstree
    pkgs.rsync
    pkgs.timg
    pkgs.tree
    pkgs.uutils-coreutils-noprefix
    pkgs.yazi
    pkgs.yt-dlp
  ] ++ optionals config.isLinux [
    pkgs.traceroute
    pkgs.usbutils
    pkgs.strace
  ] ++ optionals config.isDesktop [
    pkgs.clang_16
    pkgs.clang-tools_16
    pkgs.deno
    pkgs.gh
    pkgs.go
    pkgs.jdk
    pkgs.lld
    pkgs.maven
    pkgs.zig

    pkgs.element-desktop

    pkgs.qbittorrent
  ] ++ optionals (config.isLinux && config.isDesktop) [
    pkgs.thunderbird

    pkgs.whatsapp-for-linux

    pkgs.zulip
    pkgs.fractal

    pkgs.obs-studio

    pkgs.krita

    pkgs.libreoffice
    pkgs.hunspellDicts.en_US
    pkgs.hunspellDicts.en_GB-ize
  ];
}
