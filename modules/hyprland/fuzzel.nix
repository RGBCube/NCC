{ config, lib, ... }: with lib;

desktopUserHomeConfiguration {
  programs.fuzzel = with config.theme; enabled {
    settings.main = {
      dpi-aware  = false;
      font       = "${font.sans.name}:size=${toString font.size.big}";
      icon-theme = icons.name;

      layer     = "overlay";
      prompt    = ''"❯ "'';

      terminal = "ghostty -e";

      tabs = 4;

      horizontal-pad = padding;
      vertical-pad   = padding;
      inner-pad      = padding;
    };

    settings.colors = mapAttrs (_: color: color + "FF") {
      background     = base00;
      text           = base05;
      match          = base0A;
      selection      = base05;
      selection-text = base00;
      border         = base0A;
    };

    settings.border = {
      radius = cornerRadius;
      width  = borderWidth;
    };
  };
}
