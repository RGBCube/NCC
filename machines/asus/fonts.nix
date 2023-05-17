{ pkgs, systemFonts, ... }:

with pkgs; systemFonts [
  (nerdfonts.override {
    fonts = [
      "JetBrainsMono"
    ];
  })
]
    "editor.comments.ignoreEmptyLines": false,
    "editor.experimental.asyncTokenization": true,
    "editor.folding": false,
    "editor.fontFamily": "JetBrainsMono Nerd Font ",
    "editor.fontLigatures": true,
    "editor.fontSize": 14,
    "editor.fontWeight": "400",
    "editor.guides.bracketPairsHorizontal": true,
    "editor.inlayHints.fontSize": 11,
    "editor.inlineSuggest.enabled": true,
    "editor.lineHeight": 22,
    "editor.lineNumbers": "relative",
    "editor.minimap.enabled": false,
    "editor.renderWhitespace": "boundary",
    "editor.smoothScrolling": true,
