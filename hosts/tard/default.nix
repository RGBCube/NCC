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
    ipv4 = "";
    ipv6 = "";

    domain = "rgbcu.be";

    defaultGateway  = "";
    defaultGateway6 = "";

    interfaces.XXX = {
      ipv4.addresses = [{
        address      = config.networking.ipv4;
        prefixLength = 25;
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
