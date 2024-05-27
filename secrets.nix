with import ./keys.nix; {
  # cube
  "hosts/cube/id.age".publicKeys           = [ cube ] ++ admins;
  "hosts/cube/password.rgb.age".publicKeys = [ cube ] ++ admins;

  "hosts/cube/acme/environment.age".publicKeys = all;

  "hosts/cube/forgejo/password.runner.age".publicKeys = [ cube ] ++ admins;

  "hosts/cube/grafana/password.age".publicKeys      = [ cube ] ++ admins;

  "hosts/cube/matrix/password.secret.age".publicKeys = [ cube ] ++ admins;
  "hosts/cube/matrix/password.sync.age".publicKeys   = [ cube ] ++ admins;

  "hosts/cube/nextcloud/password.age".publicKeys  = [ cube ] ++ admins;

  "hosts/cube/restic/password.age".publicKeys = [ cube ] ++ admins;

  # disk
  "hosts/disk/id.age".publicKeys              = [ disk ] ++ admins;
  "hosts/disk/password.floppy.age".publicKeys = [ disk ] ++ admins;

  "hosts/disk/mail/password.plain.age".publicKeys = all;
  "hosts/disk/mail/password.hash.age".publicKeys  = [ disk nine ] ++ admins;

  # enka
  "hosts/enka/id.age".publicKeys             = admins;
  "hosts/enka/password.orhan.age".publicKeys = admins;
  "hosts/enka/password.said.age".publicKeys  = admins;

  # nine
  "hosts/nine/id.age".publicKeys             = [ nine ] ++ admins;
  "hosts/nine/password.seven.age".publicKeys = [ nine ] ++ admins;

  # shared
  "modules/ssh/config.age".publicKeys  = all;
}
