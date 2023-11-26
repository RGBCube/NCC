{ pkgs, upkgs, homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  services.dunst = with upkgs.theme.withHashtag; enabled {
    iconTheme = {
      name    = "Gruvbox-Dark";
      package = pkgs.gruvbox-dark-icons-gtk;
    };

    settings.global = {
      width = "(300, 900)";

      horizontal_padding = 10;
      padding            = 10;

      frame_color     = base0A;
      frame_width     = 2;
      seperator_color = "frame";

      background = background;
      foreground = lightForeground;

      alignment = "center";
      font      = "OpenSans 12";

      min_icon_size = 64;

      offset = "0x20";
      origin = "top-center";
    };

    settings.urgency_low = {
      frame_color = base0D;
      timeout     = 5;
    };

    settings.urgency_normal = {
      frame_color = base0E;
      timeout     = 10;
    };

    settings.urgency_critical = {
      frame_color = base08;
      timeout     = 15;
    };
  };
}
