let
  inherit (import ./keys.nix) all;
in {
  # shared
  "modules/common/ssh/config.age".publicKeys    = all;
  "modules/linux/restic/password.age".publicKeys = all;
}
