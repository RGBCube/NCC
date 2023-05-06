pkgs: with pkgs; []

++ [ # APPLICATIONS
  firefox
  discord
  qbittorrent
]

++ [ # DEVELOPMENT TOOLS
  # docker # Declared in docker/.
  bat
]

++ [ # EDITORS
  # neovim # Declared in neovim/.
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

++ [ (fenix.complete.withComponents [ # RUST
  "rustc"
  "rust-src"
  "cargo"
  "rustfmt"
  "clippy"
]) ]

++ [ # SHELLS
  # nushell # Declared in nushell/.
  starship
]

++ [ # VERSION CONTROL
  # git # Declared in git/.
]
