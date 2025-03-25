{ config, lib, pkgs, ... }: let
  inherit (lib) attrValues optionalAttrs;
in {
  environment.systemPackages = attrValues <| {
    inherit (pkgs)
      asciinema
      cowsay
      curlHTTP3
      dig
      doggo
      fastfetch
      fd
      hyperfine
      moreutils
      openssl
      p7zip
      pstree
      rsync
      timg
      tokei
      tree
      typos
      uutils-coreutils-noprefix
      yazi
      yt-dlp
    ;

    fortune = pkgs.fortune.override { withOffensive = true; };
  } // optionalAttrs config.isLinux {
    inherit (pkgs)
      traceroute
      usbutils
      strace
    ;
  } // optionalAttrs config.isDesktop {
    inherit (pkgs)
      clang_16
      clang-tools_16
      deno
      gh
      go
      jdk
      lld
      maven
      zig

      qbittorrent
    ;
  } // optionalAttrs (config.isLinux && config.isDesktop) {
    inherit (pkgs)
      thunderbird

      whatsapp-for-linux

      element-desktop
      zulip
      fractal

      obs-studio

      krita

      libreoffice
    ;

    inherit (pkgs.hunspellDicts)
      en_US
      en_GB-ize
    ;
  };
}
