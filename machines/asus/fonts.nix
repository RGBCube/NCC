{ pkgs, systemFonts, ... }:

with pkgs; systemFonts [
  (nerdfonts.override {
    fonts = [
      "JetBrainsMono"
    ];
  })
]
