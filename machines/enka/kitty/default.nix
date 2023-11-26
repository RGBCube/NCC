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

      inactive_tab_background = lightBackground;
      inactive_tab_foreground = lightForeground;

      color0  = base00;
      color1  = base01;
      color2  = base02;
      color3  = base03;
      color4  = base04;
      color5  = base05;
      color6  = base06;
      color7  = base07;
      color8  = base08;
      color9  = base09;
      color10 = base0A;
      color11 = base0B;
      color12 = base0C;
      color13 = base0D;
      color14 = base0E;
      color15 = base0F;
    };
  };
}
