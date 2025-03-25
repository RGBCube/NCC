{ config, lib, pkgs, ... }: let
  inherit (lib) attrValues disabled merge mkIf;
in merge

(mkIf config.isDesktop {
  console = {
    earlySetup = true;
    font       = "Lat2-Terminus16";
    packages   = [ pkgs.terminus_font ];
  };

  fonts.packages = attrValues {
    sans = config.theme.font.sans.package;
    mono = config.theme.font.mono.package;

    inherit (pkgs)
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-lgc-plus
      noto-fonts-emoji
    ;
  };
})

(mkIf config.isServer {
  fonts.fontconfig = disabled;
})
