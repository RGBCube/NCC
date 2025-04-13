inputs: self: super: let
  colors     = import ./colors.nix     inputs self super;
  filesystem = import ./filesystem.nix inputs self super;
  option     = import ./option.nix     inputs self super;
  system     = import ./system.nix     inputs self super;
  values     = import ./values.nix     inputs self super;
in colors // filesystem // option // system // values
