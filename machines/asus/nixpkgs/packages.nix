pkgs: with pkgs; []

++ [ # EDITORS
  # neovim # Declared in neovim/.
  neovim-qt
  jetbrains.idea-ultimate
]

++ [ # VERSION CONTROL
  # git # Declared in git/.
]

++ [ # SHELLS
  # nushell # Declared in nushell/.
  starship
]

++ [ # DEVELOPMENT TOOLS
  # docker # Declared in docker/.
  bat
]

++ [ # MISCELLANEOUS
  htop
  neofetch
]

++ [ # APPLICATIONS
  firefox
  discord
  qbittorrent
]

++ [ # GAMES
  openttd
]

++ [ # PYTHON
  (python311.withPackages (pkgs: with pkgs; [
    pip
    requests
  ]))
  virtualenv
  poetry
]

++ [ # LIBREOFFICE
  libreoffice
  hunspellDicts.en_US
  hunspellDicts.en_GB-ize
]

++ [ # PLASMA THEMES
  lightly-qt
]

++ [ # EMULATION
  wine
]
