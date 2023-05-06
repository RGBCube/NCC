pkgs: with pkgs; []

++ [ # NERD FONTS
  (nerdfonts.override {
    fonts = [
      "JetBrainsMono"
    ];
  })
]
