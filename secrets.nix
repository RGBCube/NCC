let
  inherit (import ./keys.nix) disk nine admins all;
in {
  # disk
  "hosts/disk/password.floppy.age".publicKeys = [ disk ] ++ admins;
  "hosts/disk/id.age".publicKeys              = [ disk ] ++ admins;

  # nine
  "hosts/nine/id.age".publicKeys                         = [ nine ] ++ admins;
  "hosts/nine/password.seven.age".publicKeys             = [ nine ] ++ admins;
  "hosts/nine/github2forgejo/environment.age".publicKeys = [ nine ] ++ admins;

  # shared
  "modules/common/ssh/config.age".publicKeys     = all;
  "modules/linux/restic/password.age".publicKeys = all;

  "modules/acme/environment.age".publicKeys    = all;
  "modules/mail/password.hash.age".publicKeys  = all;
  "modules/mail/password.plain.age".publicKeys = all;
}
