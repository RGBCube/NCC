{ config, lib, pkgs, ... }: let
  inherit (lib) attrValues enabled merge mkIf;
in merge <| mkIf config.isDesktop {
  programs.thunar = enabled {
    plugins = attrValues {
      inherit (pkgs.xfce)
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ;
    };
  };

  environment.systemPackages = attrValues {
    inherit (pkgs)
      ark
      ffmpegthumbnailer
      libgsf
    ;

    inherit (pkgs.xfce)
      tumbler
    ;
  };
}
