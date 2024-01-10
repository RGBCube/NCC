users: let
  configuration = import ./configuration.nix users;
  merge         = import ./merge.nix;
  values        = import ./values.nix;
in configuration // merge // values
