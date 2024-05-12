{ config, lib, keys, ... }: with lib; merge

(systemConfiguration {
  system.stateVersion  = "23.11";
  nixpkgs.hostPlatform = "x86_64-linux";

  secrets.id.file            = ./id.age;
  secrets.tailPassword.file  = ./password.tail.age;

  users.users = {
    root.hashedPasswordFile = config.secrets.tailPassword.path;

    tail = sudoUser {
      description                 = "Tail";
      openssh.authorizedKeys.keys = [ keys.enka ];
      hashedPasswordFile          = config.secrets.tailPassword.path;
    };
  };

  services.openssh.hostKeys = [{
    type = "ed25519";
    path = config.secrets.id.path;
  }];

  networking = {
    ipv4 = "143.198.73.55";
    ipv6 = "2604:a880:4:1d0::86d:a000";

    domain = "rgbcu.be";

    defaultGateway  = "143.198.64.1";
    defaultGateway6 = "2604:a880:4:1d0::1";

    interfaces.ens3 = {
      ipv4.addresses = [{
        address      = config.networking.ipv4;
        prefixLength = 20;
      }];

      ipv6.addresses = [{
        address      = config.networking.ipv6;
        prefixLength = 64;
      }];
    };
  };
})

(homeConfiguration {
  home.stateVersion = "23.11";
})
