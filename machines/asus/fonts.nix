{ pkgs, systemConfiguration, systemFonts, ... }:

(with pkgs; systemFonts [
  (nerdfonts.override {
    fonts = [
      "JetBrainsMono"
    ];
  })
])

//

(systemConfiguration {
  console = {
    earlySetup = true;
    font = "Lat2-Terminus16";
    packages = [ pkgs.terminus ];
  };
})
