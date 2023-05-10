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
  jetbrains.idea-ultimate
]

++ [ # EMULATION
  wine
]

++ [ # FIRMWARE
  linux-firmware
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

++ [ # COMPILERS & TOOLING
  gcc
  go
  (fenix.complete.withComponents [
    "rustc"
    "rust-src"
    "cargo"
    "rustfmt"
    "clippy"
  ])
]

++ [ # PYTHON
  (python311.withPackages (pkgs: with pkgs; [
    pip
    requests
  ]))
  virtualenv
  poetry
]
