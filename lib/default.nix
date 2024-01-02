lib: users: let
  configuration = import ./configuration.nix lib users;
  merge         = import ./merge.nix lib;
  values        = import ./values.nix;
in configuration // merge // values
