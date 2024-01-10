{ ulib, theme, ... }: with ulib;

desktopHomeConfiguration {
  programs.fuzzel = with theme; enabled {
    settings.main = {
      dpi-aware  = false;
      font       = "${font.sans.name}:size=${toString font.size.big}";
      icon-theme = icons.name;

      layer     = "overlay";
      prompt    = ''"❯ "'';

      terminal = "ghostty --gtk-single-instance=true -e";

      tabs = 4;

      horizontal-pad = padding;
      vertical-pad   = padding;
      inner-pad      = padding;
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
      radius = cornerRadius;
      width  = borderWidth;
    };
  };
}
