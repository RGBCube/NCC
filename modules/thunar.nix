{ lib, pkgs, ... }: with lib; merge

(desktopSystemConfiguration {
  programs.thunar = enabled {
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-media-tags-plugin
      thunar-volman
    ];
  };
})

(desktopSystemPackages (with pkgs; [
  ark
  ffmpegthumbnailer
  libgsf
  xfce.tumbler
]))
