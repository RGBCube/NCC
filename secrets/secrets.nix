let
  keys = {
    rgbcube  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRSLWxpIMOZIQv9ggDnAwSxmux/TZvuEPgq2HFiH+oI2OE07xYQAiroBVI5HH+aIg1nwpYtArANoD8V9Hrx2XCo2py/fMi9LhJWNMlFVcRLqYrCmrZYhBqZhxXIdY+wXqkSE7kvTKsz84BrhwilfA/bqTgVw2Ro6w0RnTzUhlYx4w10DT3isN09cQJMgvuyWNRlpGpkEGhPwyXythKM2ERoHTfq/XtpiGZQeLr6yoTTd9q4rbvnGGka5IUEz3RrmeXEs13l02IY6dCUFJkRRsK8dvB9zFjQyM08IqdaoHeudZoCOsnl/AiegZ7C5FoYEKIXY86RqxS3TH3nwuxe2fXTNr9gwf2PumM1Yh2WxV4+pHQOksxW8rWgv1nXMT5AG0RrJxr+S0Nn7NBbzCImrprX3mg4vJqT24xcUjUSDYllEMa2ioXGCeff8cwVKK/Ly5fwj0AX1scjiw+b7jD6VvDLA5z+ALwCblxiRMCN0SOMk9/V2Xsg9YIRMHyQwpqu8k= nixos@enka";
    cube     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINMkCJeHcD0SIOZ4HkyF6rqUmbvlKhSha3HWMZ0hbIjp rgb@cube";
  };

  key = key: [ key ];
in with keys; {
  inherit keys;

  "cube/id.age".publicKeys = key cube;

  "cube/password.hash.mail.age".publicKeys = key cube;
  "cube/password.hash.rgb.age".publicKeys  = key cube;

  "cube/password.acme.age".publicKeys = key cube;

  "cube/password.grafana.age".publicKeys      = key cube;
  "cube/password.mail.grafana.age".publicKeys = key cube;

  "cube/password.secret.matrix-synapse.age".publicKeys = key cube;
  "cube/password.sync.matrix-synapse.age".publicKeys = key cube;

  "cube/password.nextcloud.age".publicKeys = key cube;

  "enka/password.hash.orhan.age".publicKeys = key rgbcube;
  "enka/password.hash.said.age".publicKeys  = key rgbcube;
}
