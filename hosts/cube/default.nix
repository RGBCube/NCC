{ ulib, ... }: with ulib; merge

(let
  rgbKey  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRSLWxpIMOZIQv9ggDnAwSxmux/TZvuEPgq2HFiH+oI2OE07xYQAiroBVI5HH+aIg1nwpYtArANoD8V9Hrx2XCo2py/fMi9LhJWNMlFVcRLqYrCmrZYhBqZhxXIdY+wXqkSE7kvTKsz84BrhwilfA/bqTgVw2Ro6w0RnTzUhlYx4w10DT3isN09cQJMgvuyWNRlpGpkEGhPwyXythKM2ERoHTfq/XtpiGZQeLr6yoTTd9q4rbvnGGka5IUEz3RrmeXEs13l02IY6dCUFJkRRsK8dvB9zFjQyM08IqdaoHeudZoCOsnl/AiegZ7C5FoYEKIXY86RqxS3TH3nwuxe2fXTNr9gwf2PumM1Yh2WxV4+pHQOksxW8rWgv1nXMT5AG0RrJxr+S0Nn7NBbzCImrprX3mg4vJqT24xcUjUSDYllEMa2ioXGCeff8cwVKK/Ly5fwj0AX1scjiw+b7jD6VvDLA5z+ALwCblxiRMCN0SOMk9/V2Xsg9YIRMHyQwpqu8k= nixos@enka";
  cobbKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCc2bBLcviqfLjLJKwBG2+HEukqR1UkKmCr4HP+4Upiux6K427NW2+Uk7TxQKnS82IVaTGI2+2GMd4ZYYUcirf5OtZT9tTP9zhVCbTXWyDslcaL4yRTzcHdetHAfSloPuq3JoWq66aP9Y3adee7eEOe1HB59ZdoUoZx/D4B9GPBO2P2b22cwY9twEJxLWmU2kEBkNOGu176kDRggDsq/wLqnSaX8u+/DOPifHajmrf1jdzNYx6GyHxmG1r66KYMvd+bOhfnDQNast/IiYHndpmUPcSFdH3jVxXCAdRKFW4g9Gasa3mJVchswfGI3ZGaD453MKXPYUX0ufxIktneOUefvMVgJ6zZ+IRL++J+Pw3GHx+Pla1SOnoP35IQS7YYeCCS3vPUKugCvq/aiZa/eOdOTd6dP61i1plhobO7kSPlAGWBtpORlXN9JZGfpBhy0dF0Akix6oomFUDp+QdMMI2OacFekdLbN9zHvp+ZPvc0CSpFyH/r8j1cg0/IF9U2Ivs= ic@ic-debian-macbook";
  zeroKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHmeYtW32pPgOBy1m5YfFTb98D6WBGNV5TM5/G2uvBBV dustin@unknown";
in systemConfiguration {
  system.stateVersion = "23.05";

  nixpkgs.hostPlatform = "x86_64-linux";

  time.timeZone = "Europe/Amsterdam";

  users.users.rgb = normalUser {
    description = "RGB";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ rgbKey ];
  };

  users.users.cobb = normalUser {
    description = "Cobb";
    openssh.authorizedKeys.keys = [ rgbKey cobbKey ];
  };

  users.users.zero = normalUser {
    description = "Zero";
    openssh.authorizedKeys.keys = [ rgbKey zeroKey ];
  };
})

(homeConfiguration {
  home.stateVersion = "23.11";
})
