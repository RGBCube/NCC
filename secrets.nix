let
  inherit (import ./keys.nix) best cube disk nine admins all;
in {
  # best
  "hosts/best/id.age".publicKeys            = [ best ] ++ admins;
  "hosts/best/password.the.age".publicKeys  = [ best ] ++ admins;

  "hosts/best/nix-serve/key.age".publicKeys = [ best ] ++ admins;

  # cube
  "hosts/cube/id.age".publicKeys                      = [ cube ] ++ admins;
  "hosts/cube/password.rgb.age".publicKeys            = [ cube ] ++ admins;

  "hosts/cube/forgejo/password.runner.age".publicKeys = [ cube ] ++ admins;
  "hosts/cube/grafana/password.age".publicKeys        = [ cube ] ++ admins;
  "hosts/cube/matrix/password.secret.age".publicKeys  = [ cube ] ++ admins;
  "hosts/cube/nextcloud/password.age".publicKeys      = [ cube ] ++ admins;

  # disk
  "hosts/disk/id.age".publicKeys              = [ disk ] ++ admins;
  "hosts/disk/password.floppy.age".publicKeys = [ disk ] ++ admins;

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
