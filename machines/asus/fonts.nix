{ pkgs, fonts, ... }:

with pkgs; fonts [
  (nerdfonts.override {
    fonts = [
      "JetBrainsMono"
    ];
  })
]
