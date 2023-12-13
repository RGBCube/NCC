{ ulib, pkgs, theme, ... }: with ulib; merge

(systemConfiguration {
  console = {
    earlySetup = true;
    font       = "Lat2-Terminus16";
    packages   = with pkgs; [ terminus_font ];
  };
})

(systemFonts (with pkgs; [
  theme.font.sans.package
  theme.font.mono.package

  noto-fonts
  noto-fonts-cjk-sans
  noto-fonts-lgc-plus
  noto-fonts-emoji
]))
