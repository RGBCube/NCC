{ homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  programs.fuzzel = enabled {
    settings = ''
      font = JetBrainsMono:size=12
      prompt = "❯ "

      terminal = kitty

      tabs = 4

      horizontal-pad = 10
      vertical-pad   = 10
      inner-pad      = 5

      background-color = 1D2021
      text             = DDC7A1
      match            = D79921
      selection        = DDC7A1
      selection-text   = 1D2021
      border = D79921

      [border]
      radius = 0
    '';
  };
}
