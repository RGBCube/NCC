{ lib, pkgs, theme, systemConfiguration, systemFonts, ... }: lib.recursiveUpdate

(systemConfiguration {
  console = {
    earlySetup = true;
    font       = "Lat2-Terminus16";
    packages   = with pkgs; [
      terminus-nerdfont
    ];
  };
})

(with pkgs; systemFonts [
  theme.font.sans.package
  theme.font.mono.package

  noto-fonts
  noto-fonts-cjk-sans
  noto-fonts-lgc-plus
  noto-fonts-emoji
])
