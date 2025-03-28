{ config, lib, ... }: let
  inherit (lib) merge mkIf;
in merge <| mkIf config.isDesktop {
  home-manager.sharedModules = [{
    services.dunst = with config.theme.withHashtag; enabled {
      iconTheme = icons;

      settings.global = {
        width = "(300, 900)";

        dmenu = "fuzzel --dmenu";

        corner_radius      = cornerRadius;
        gap_size           = margin;
        horizontal_padding = padding;
        padding            = padding;

        frame_color     = base0A;
        frame_width     = borderWidth;
        separator_color = "frame";

        background = base00;
        foreground = base05;

        alignment = "center";
        font      = "${font.sans.name} ${toString font.size.normal}";

        min_icon_size = 64;

        offset = "0x${toString margin}";
        origin = "top-center";
      };

      settings.urgency_low = {
        frame_color = base0A;
        timeout     = 5;
      };

      settings.urgency_normal = {
        frame_color = base09;
        timeout     = 10;
      };

      settings.urgency_critical = {
        frame_color = base08;
        timeout     = 15;
      };
    };
  }];
}
