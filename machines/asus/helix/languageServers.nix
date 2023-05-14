{ pkgs, homePackages, ... }:

with pkgs; homePackages "nixos" [
  # BASH
  nodePackages.bash-language-server

  # CMAKE
  cmake-language-server

  # GO
  gopls

  # KOTLIN
  kotlin-language-server

  # PYTHON
  nodePackages.pyright
  black

  # JAVASCRIPT/TYPESCRIPT
  nodePackages.typescript-language-server

  # LATEX
  texlab

  # LUA
  lua-language-server

  # MARKDOWN
  marksman

  # NIX
  nil

  # RUST
  rust-analyzer

  # YAML
  nodePackages.yaml-language-server

  # ZIG
  zls
]
