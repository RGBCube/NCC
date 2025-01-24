let
  inherit (import ./keys.nix) nine admins all;
in {
  # nine
  "hosts/nine/id.age".publicKeys             = [ nine ] ++ admins;
  "hosts/nine/password.seven.age".publicKeys = [ nine ] ++ admins;

  # shared
  "modules/common/ssh/config.age".publicKeys    = all;
  "modules/linux/restic/password.age".publicKeys = all;
}
