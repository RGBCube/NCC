lib: lib.nixosSystem ({ config, keys, lib, ... }: let
  inherit (lib) collectNix remove;
in {
  imports = collectNix ./. |> remove ./default.nix;

  secrets.id.file           = ./id.age;
  services.openssh.hostKeys = [{
    type = "ed25519";
    path = config.secrets.id.path;
  }];

  secrets.sevenPassword.file  = ./password.seven.age;
  users.users                 = {
    root.hashedPasswordFile = config.secrets.sevenPassword.path;

    seven = {
      description                 = "Hungry Seven";
      openssh.authorizedKeys.keys = keys.admins;
      hashedPasswordFile          = config.secrets.sevenPassword.path;
      isNormalUser                = true;
      extraGroups                 = [ "wheel" ];
    };

    backup = {
      description                 = "Backup";
      openssh.authorizedKeys.keys = keys.all;
      hashedPasswordFile          = config.secrets.sevenPassword.path;
      isNormalUser                = true;
    };
  };

  home-manager.users = {
    root   = {};
    seven  = {};
    backup = {};
  };

  networking = let
    interface = "enp4s0";
  in {
    hostName = "nine";

    ipv4 = "152.53.2.105";
    ipv6 = "2a0a:4cc0:0:12d9::";

    domain = "rgbcu.be";

    defaultGateway = {
      inherit interface;

      address = "152.53.0.1";
    };

    defaultGateway6 = {
      inherit interface;

      address = "fe80::1";
    };

    interfaces.${interface} = {
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

  nixpkgs.hostPlatform       = "aarch64-linux";
  system.stateVersion        = "23.11";
  home-manager.sharedModules = [{
    home.stateVersion = "23.11";
  }];
})
