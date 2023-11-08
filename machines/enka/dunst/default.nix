{ pkgs, homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  services.dunst = enabled {
    iconTheme = {
      name    = "gruvbox-dark";
      package = pkgs.gruvbox-dark-icons-gtk;
    };

    settings.global = {
      horizontal_padding = 10;
      padding            = 10;

      frame_color     = "#D79921";
      frame_width     = 1;
      seperator_color = "frame";

      background = "#1D2021";
      foreground = "#DDC7A1";

      alignment = "left";
      font      = "JetBrainsMono 12";
    };

    settings.urgency_low = {
      frame_color = "#94A6FF";
      timeout     = 5;
    };

    settings.urgency_normal = {
      frame_color = "#FAA41A";
      timeout     = 10;
    };

    settings.urgency_critical = {
      frame_color = "#F15D22";
      timeout     = 15;
    };
  };
}
