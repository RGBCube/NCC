users: let
  configuration = import ./configuration.nix users;
  merge         = import ./merge.nix;
  ssl           = import ./ssl.nix;
  values        = import ./values.nix;
in configuration // merge // ssl // values
