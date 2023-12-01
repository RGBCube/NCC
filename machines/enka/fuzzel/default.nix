{ upkgs, homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  programs.fuzzel = with upkgs.theme; enabled {
    settings.main = {
      dpi-aware  = false;
      font       = "${font.sans.name}:size=${toString font.size.big}";
      icon-theme = icons.name;

      layer     = "overlay";
      prompt    = ''"❯ "'';

      terminal = "kitty";

      tabs = 4;

      horizontal-pad = 10;
      vertical-pad   = 10;
      inner-pad      = 10;
    };

    settings.colors = {
      background     = base00 + "FF";
      text           = base05 + "FF";
      match          = base0A + "FF";
      selection      = base05 + "FF";
      selection-text = base00 + "FF";
      border         = base0A + "FF";
    };

    settings.border = {
      radius = corner-radius;
      width  = border-width;
    };
  };
}
