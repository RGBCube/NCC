{ homeConfiguration, enabled, ... }:

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
      background     = "1D2021FF";
      text           = "DDC7A1FF";
      match          = "D79921FF";
      selection      = "DDC7A1FF";
      selection-text = "1D2021FF";
      border         = "D79921FF";
    };

    settings.border = {
      radius = 0;
      width = 3;
    };
  };
}
