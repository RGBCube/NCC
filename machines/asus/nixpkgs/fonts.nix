{ pkgs, ... }: with pkgs; []

++ [ (nerdfonts.override { fonts = [ # NERD FONTS
  "JetBrainsMono"
]; }) ]
