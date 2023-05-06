pkgs: with pkgs; []

++ [ # APPLICATIONS
  firefox
  discord
  qbittorrent
]

++ [ # DEVELOPMENT TOOLS
  bat
]

++ [ # EDITORS
  neovim-qt
  jetbrains.idea-ultimate
]

++ [ # EMULATION
  wine
]

++ [ # GAMES
  openttd
]

++ [ # LIBREOFFICE
  libreoffice
  hunspellDicts.en_US
  hunspellDicts.en_GB-ize
]

++ [ # MISCELLANEOUS
  htop
  neofetch
]

++ [ # PLASMA THEMES
  lightly-qt
]

++ [ # PROGRAMMING LANGUAGES
  go
]

++ [ # PYTHON
  (python311.withPackages (pkgs: with pkgs; [
    pip
    requests
  ]))
  virtualenv
  poetry
]

++ [ # RUST
  (fenix.complete.withComponents [
    "rustc"
    "rust-src"
    "cargo"
    "rustfmt"
    "clippy"
  ])
]

++ [ # SHELLS
  starship
]
