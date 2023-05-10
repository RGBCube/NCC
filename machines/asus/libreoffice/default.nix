{ pkgs, packages, ... }:

with pkgs; packages [
  libreoffice
  hunspellDicts.en_US
  hunspellDicts.en_GB-ize
]
