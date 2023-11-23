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

    settings = let
      inherit (upkgs) theme;
    in {
      allow_remote_control    = true;
      confirm_os_window_close = 0;
      focus_follows_mouse     = true;
      mouse_hide_wait         = 0;
      window_padding_width    = 10;

      scrollback_lines = 100000;
      scrollback_pager = "bat --chop-long-lines";

      cursor             = "#" + theme.foreground;
      cursor_theme_color = "#" + theme.background;
      cursor_shape       = "beam";

      url_color = "#" + theme.low;

      strip_trailing_spaces = "always";

      enable_audio_bell = false;

      active_border_color   = "#" + theme.activeHighlight;
      inactive_border_color = "#" + theme.inactiveHighlight;
      window_border_width   = "0pt";

      background = "#" + theme.background;
      foreground = "#" + theme.foreground;
      
      selection_background = "#" + theme.foreground;
      selection_foreground = "#" + theme.background;

      tab_bar_edge  = "top";
      tab_bar_style = "powerline";

      active_tab_background = "#" + theme.background;
      active_tab_foreground = "#" + theme.foreground;

      inactive_tab_background = "#" + theme.backgroundLight;
      inactive_tab_foreground = "#" + theme.foreground;

      color0  = "#665C54";
      color2  = "#98971A";
      color3  = "#D79921";
      color4  = "#458588";
      color5  = "#B16286";
      color6  = "#689D6A";
      color7  = "#A89984";
      color8  = "#7C6F64";
      color9  = "#FB4934";
      color10 = "#B8BB26";
      color11 = "#FABD2F";
      color12 = "#83A598";
      color13 = "#D3869B";
      color14 = "#8EC07C";
      color15 = "#BDAE93";
    };
  };
}
