{ upkgs, homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  programs.kitty = with upkgs.theme.withHashtag; enabled {
    font = with font; {
      inherit (mono) name package;

      size = size.normal;
    };

    theme = "Gruvbox Dark";

    settings = {
      allow_remote_control    = true;
      confirm_os_window_close = 0;
      focus_follows_mouse     = true;
      mouse_hide_wait         = 0;
      window_padding_width    = 10;

      scrollback_lines = 100000;
      scrollback_pager = "bat --chop-long-lines";

      cursor             = base05;
      cursor_text_color = base00;
      cursor_shape       = "beam";

      url_color = base0D;

      strip_trailing_spaces = "always";

      enable_audio_bell = false;

      active_border_color   = base0A;
      inactive_border_color = base01;
      window_border_width   = "0pt";

      background = base00;
      foreground = base05;
      
      selection_background = base02;
      selection_foreground = base00;

      tab_bar_edge  = "top";
      tab_bar_style = "powerline";

      active_tab_background = base00;
      active_tab_foreground = base05;

      inactive_tab_background = base01;
      inactive_tab_foreground = base05;

      color0  = base00;
      color1  = base08;
      color2  = base0B;
      color3  = base0A;
      color4  = base0D;
      color5  = base0E;
      color6  = base0C;
      color7  = base05;
      color8  = base03;
      color9  = base08;
      color10 = base0B;
      color11 = base0A;
      color12 = base0D;
      color13 = base0E;
      color14 = base0C;
      color15 = base07;
      color16 = base09;
      color17 = base0F;
      color18 = base01;
      color19 = base02;
      color20 = base04;
      color21 = base06;
    };
  };
}
