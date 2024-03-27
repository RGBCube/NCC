let
  keys = import ./keys.nix;
in with builtins.mapAttrs (_: value: [ value ]) keys; {
  "hosts/enka/password.orhan.age".publicKeys = enka;
  "hosts/enka/password.said.age".publicKeys  = enka;

  "hosts/cube/acme/password.age".publicKeys                  = cube;
  "hosts/cube/forjego/password.mail.age".publicKeys          = cube;
  "hosts/cube/forjego/password.runner.age".publicKeys        = cube;
  "hosts/cube/grafana/password.age".publicKeys               = cube;
  "hosts/cube/grafana/password.mail.age".publicKeys          = cube;
  "hosts/cube/mail/password.age".publicKeys                  = cube;
  "hosts/cube/matrix-synapse/password.secret.age".publicKeys = cube;
  "hosts/cube/matrix-synapse/password.sync.age".publicKeys   = cube;
  "hosts/cube/nextcloud/password.age".publicKeys             = cube;
  "hosts/cube/password.rgb.age".publicKeys                   = cube;
}

