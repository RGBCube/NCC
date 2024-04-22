let
  keys = import ./keys.nix;
in with keys; {
  ### cube
  "hosts/cube/password.rgb.age".publicKeys       = [ cube enka ];

  "hosts/cube/password.plain.mail.age".publicKeys = [ cube enka ];
  "hosts/cube/password.hash.mail.age".publicKeys  = [ cube enka ];

  "hosts/cube/forgejo/password.runner.age".publicKeys = [ cube enka ];

  "hosts/cube/grafana/password.age".publicKeys      = [ cube enka ];

  "hosts/cube/matrix/password.secret.age".publicKeys = [ cube enka ];
  "hosts/cube/matrix/password.sync.age".publicKeys   = [ cube enka ];

  "hosts/cube/nextcloud/password.age".publicKeys  = [ cube enka ];

  ### disk

  "hosts/disk/password.floppy.age".publicKeys = [ disk enka ];

  ### enka
  "hosts/enka/password.orhan.age".publicKeys = [ enka ];
  "hosts/enka/password.said.age".publicKeys  = [ enka ];

  ### shared

  "hosts/password.acme.age".publicKeys = [ cube disk enka ];
}
