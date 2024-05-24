let
  keys = import ./keys.nix;

  all = builtins.attrValues keys;

  admins     = with keys; [ enka pala ];
  withAdmins = key: [ key ] ++ admins;
in with keys; {
  # cube
  "hosts/cube/id.age".publicKeys           = withAdmins cube;
  "hosts/cube/password.rgb.age".publicKeys = withAdmins cube;

  "hosts/cube/acme/environment.age".publicKeys = all;

  "hosts/cube/forgejo/password.runner.age".publicKeys = withAdmins cube;

  "hosts/cube/grafana/password.age".publicKeys      = withAdmins cube;

  "hosts/cube/matrix/password.secret.age".publicKeys = withAdmins cube;
  "hosts/cube/matrix/password.sync.age".publicKeys   = withAdmins cube;

  "hosts/cube/nextcloud/password.age".publicKeys  = withAdmins cube;

  "hosts/cube/restic/password.age".publicKeys = withAdmins cube;

  # disk
  "hosts/disk/id.age".publicKeys              = withAdmins disk;
  "hosts/disk/password.floppy.age".publicKeys = withAdmins disk;

  "hosts/disk/mail/password.plain.age".publicKeys = all;
  "hosts/disk/mail/password.hash.age".publicKeys  = [ disk nine ] ++ admins;

  # enka
  "hosts/enka/id.age".publicKeys             = admins;
  "hosts/enka/password.orhan.age".publicKeys = admins;
  "hosts/enka/password.said.age".publicKeys  = admins;

  # nine
  "hosts/nine/id.age".publicKeys             = withAdmins nine;
  "hosts/nine/password.seven.age".publicKeys = withAdmins nine;

  # tard
  "hosts/tard/id.age".publicKeys            = withAdmins tard;
  "hosts/tard/password.tail.age".publicKeys = withAdmins tard;

  # shared
  "modules/ssh/config.age".publicKeys  = all;
}
