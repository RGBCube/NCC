{ upkgs, homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  programs.fuzzel = enabled {
    settings.main = {
      font      = "OpenSans:size=18";
      dpi-aware = false;
      prompt    = ''"❯ "'';

      terminal = "kitty";

      tabs = 4;

      horizontal-pad = 10;
      vertical-pad   = 10;
      inner-pad      = 10;
    };

    settings.colors = with upkgs.theme; {
      background     = background      + "FF";
      text           = lightForeground + "FF";
      match          = base0A          + "FF";
      selection      = lightForeground + "FF";
      selection-text = background      + "FF";
      border         = base0A          + "FF";
    };

    settings.border = {
      radius = 0;
      width = 2;
    };
  };
}
