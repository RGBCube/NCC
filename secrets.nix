let
  keys = import ./keys.nix;

  all = builtins.attrValues keys;
in with keys; {
  ### cube
  "hosts/cube/id.age".publicKeys           = [ cube enka ];
  "hosts/cube/password.rgb.age".publicKeys = [ cube enka ];

  "hosts/cube/forgejo/password.runner.age".publicKeys = [ cube enka ];

  "hosts/cube/grafana/password.age".publicKeys      = [ cube enka ];

  "hosts/cube/matrix/password.secret.age".publicKeys = [ cube enka ];
  "hosts/cube/matrix/password.sync.age".publicKeys   = [ cube enka ];

  "hosts/cube/nextcloud/password.age".publicKeys  = [ cube enka ];

  "hosts/cube/restic/password.age".publicKeys = [ cube enka ];

  ### disk
  "hosts/disk/id.age".publicKeys              = [ disk enka ];
  "hosts/disk/password.floppy.age".publicKeys = [ disk enka ];

  "hosts/disk/mail/password.plain.age".publicKeys = [ cube disk enka ]; # TODO: Move to shared.
  "hosts/disk/mail/password.hash.age".publicKeys  = [ disk enka ];

  ### enka
  "hosts/enka/password.orhan.age".publicKeys = [ enka ];
  "hosts/enka/password.said.age".publicKeys  = [ enka ];

  ### shared
  "hosts/password.acme.age".publicKeys = all;
  "modules/ssh/config.age".publicKeys  = all;
}
