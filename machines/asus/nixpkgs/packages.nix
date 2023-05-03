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

++ [ # PYTHON
  (python311.withPackages (pkgs: with pkgs; [
    pip
    requests
  ]))
  virtualenv
  poetry
]

++ [ # APPLICATIONS
  firefox
  discord
  qbittorrent
  lightly-qt
]

++ [ # LIBREOFFICE
  libreoffice
  hunspellDicts.en_US
  hunspellDicts.en_GB-ize
]

++ [ # GAMES
  openttd
]

++ [ # EMULATION
  wine
]
