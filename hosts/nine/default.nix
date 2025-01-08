{ config, lib, keys, ... }: with lib; merge

(systemConfiguration {
  system.stateVersion  = "23.11";
  nixpkgs.hostPlatform = "aarch64-linux";

  secrets.id.file             = ./id.age;
  secrets.sevenPassword.file  = ./password.seven.age;

  users.users = {
    root.hashedPasswordFile = config.secrets.sevenPassword.path;

    seven = sudoUser {
      description                 = "Hungry Seven";
      openssh.authorizedKeys.keys = keys.admins;
      hashedPasswordFile          = config.secrets.sevenPassword.path;
    };

    backup = normalUser {
      description                 = "Backup";
      openssh.authorizedKeys.keys = keys.all;
      hashedPasswordFile          = config.secrets.sevenPassword.path;
    };
  };

  services.openssh.hostKeys = [{
    type = "ed25519";
    path = config.secrets.id.path;
  }];

  networking = {
    ipv4 = "152.53.2.105";
    ipv6 = "2a0a:4cc0::12d9";

    domain = "rgbcu.be";

    defaultGateway  = "152.53.0.1";
    defaultGateway6 = "fe80::1";

    interfaces.enp4s0 = {
      ipv4.addresses = [{
        address      = config.networking.ipv4;
        prefixLength = 22;
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
