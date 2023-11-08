{ theme, homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  programs.fuzzel = enabled {
    settings.main = {
      font   = "JetBrainsMono:size=12";
      prompt = ''"❯ "'';

      terminal = "kitty";

      tabs = 4;

      horizontal-pad = 10;
      vertical-pad   = 10;
      inner-pad      = 10;
    };

    settings.colors = {
      background     = theme.background      + theme.transparency;
      text           = theme.foreground      + theme.transparency;
      match          = theme.activeHighlight + theme.transparency;
      selection      = theme.foreground      + theme.transparency;
      selection-text = theme.background      + theme.transparency;
      border         = theme.activeHighlight + theme.transparency;
    };

    settings.border = {
      radius = 0;
      width = 2;
    };
  };
}
