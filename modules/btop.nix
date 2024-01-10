{ ulib, theme, ... }: with ulib;

homeConfiguration {
  xdg.configFile."btop/themes/base16.theme".text = theme.btopTheme;

  programs.btop = enabled {
    settings.color_theme = "base16";

    settings.rounded_corners = theme.cornerRadius != 0;
  };
}
