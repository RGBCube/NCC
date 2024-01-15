rec {
  keys = {
    rgbcube  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRSLWxpIMOZIQv9ggDnAwSxmux/TZvuEPgq2HFiH+oI2OE07xYQAiroBVI5HH+aIg1nwpYtArANoD8V9Hrx2XCo2py/fMi9LhJWNMlFVcRLqYrCmrZYhBqZhxXIdY+wXqkSE7kvTKsz84BrhwilfA/bqTgVw2Ro6w0RnTzUhlYx4w10DT3isN09cQJMgvuyWNRlpGpkEGhPwyXythKM2ERoHTfq/XtpiGZQeLr6yoTTd9q4rbvnGGka5IUEz3RrmeXEs13l02IY6dCUFJkRRsK8dvB9zFjQyM08IqdaoHeudZoCOsnl/AiegZ7C5FoYEKIXY86RqxS3TH3nwuxe2fXTNr9gwf2PumM1Yh2WxV4+pHQOksxW8rWgv1nXMT5AG0RrJxr+S0Nn7NBbzCImrprX3mg4vJqT24xcUjUSDYllEMa2ioXGCeff8cwVKK/Ly5fwj0AX1scjiw+b7jD6VvDLA5z+ALwCblxiRMCN0SOMk9/V2Xsg9YIRMHyQwpqu8k= nixos@enka";
    cube     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINMkCJeHcD0SIOZ4HkyF6rqUmbvlKhSha3HWMZ0hbIjp rgb@cube";
  };

  "cube/id.age".publicKeys                    = [ keys.rgbcube ];

  "cube/password.hash.mail.age".publicKeys    = [ keys.cube ];
  "cube/password.hash.rgb.age".publicKeys     = [ keys.cube ];

  "cube/password.acme.age".publicKeys         = [ keys.cube ];
  "cube/password.grafana.age".publicKeys      = [ keys.cube ];
  "cube/password.mail.grafana.age".publicKeys = [ keys.cube ];
  "cube/password.nextcloud.age".publicKeys    = [ keys.cube ];

  "enka/password.hash.orhan.age".publicKeys   = [ keys.rgbcube ];
  "enka/password.hash.said.age".publicKeys    = [ keys.rgbcube ];
}
