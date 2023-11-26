{ pkgs, upkgs, homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  programs.kitty = enabled {
    font.name    = "JetBrainsMono Nerd Font";
    font.size    = 12;
    font.package = (pkgs.nerdfonts.override {
      fonts = [
        "JetBrainsMono"
      ];
    });

    theme = "Gruvbox Dark";

    settings = with upkgs.theme.withHashtag; {
      allow_remote_control    = true;
      confirm_os_window_close = 0;
      focus_follows_mouse     = true;
      mouse_hide_wait         = 0;
      window_padding_width    = 10;

      scrollback_lines = 100000;
      scrollback_pager = "bat --chop-long-lines";

      cursor             = lightForeground;
      cursor_theme_color = background;
      cursor_shape       = "beam";

      url_color = base0D;

      strip_trailing_spaces = "always";

      enable_audio_bell = false;

      active_border_color   = base0A;
      inactive_border_color = base01;
      window_border_width   = "0pt";

      background = background;
      foreground = lightForeground;
      
      selection_background = lightForeground;
      selection_foreground = background;

      tab_bar_edge  = "top";
      tab_bar_style = "powerline";

      active_tab_background = background;
      active_tab_foreground = lightForeground;

      inactive_tab_background = lighterBackground;
      inactive_tab_foreground = lightForeground;

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
