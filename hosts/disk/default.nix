{ config, lib, keys, ... }: with lib; merge

(systemConfiguration {
  system.stateVersion  = "23.11";
  nixpkgs.hostPlatform = "x86_64-linux";

  networking.domain = "rgbcu.be";

  secrets.floppyPassword.file  = ./password.floppy.age;

  users.users = {
    root.hashedPasswordFile = config.secrets.floppyPassword.path;

    floppy = sudoUser {
      description                 = "Floppy";
      openssh.authorizedKeys.keys = [ keys.enka ];
      hashedPasswordFile          = config.secrets.floppyPassword.path;
    };
  };

  networking = {
    defaultGateway  = "23.164.232.1";
    defaultGateway6 = "2602:f9f7::1";

    interfaces.ens32 = {
      ipv4.addresses = [{
        address      = "23.164.232.40";
        prefixLength = 25;
      }];

      ipv6.addresses = [{
        address      = "2602:f9f7::40";
        prefixLength = 64;
      }];
    };
  };
})

(homeConfiguration {
  home.stateVersion = "23.11";
})
