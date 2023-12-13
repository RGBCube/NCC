{ ulib, theme, ... }: with ulib;

systemConfiguration {
  services.kmscon = enabled {
    extraConfig = "xkb-layout=tr";
    fonts       = [ theme.font.mono ];
    hwRender    = true;
  };
}
