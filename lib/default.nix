lib: users: let
  configuration = import ./configuration.nix users;
  merge         = import ./merge.nix lib;
  ssl           = import ./ssl.nix;
  values        = import ./values.nix;
in configuration // merge // ssl // values
