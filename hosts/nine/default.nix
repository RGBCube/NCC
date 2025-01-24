lib: lib.nixosSystem ({ config, keys, lib, ... }: let
  inherit (lib) collect remove;
in {
  imports = collect ./. |> remove ./default.nix;

  nixpkgs.hostPlatform = "aarch64-linux";

  system.stateVersion  = "23.11";
  home-manager.sharedModules = [{
    home.stateVersion = "23.11";
  }];

  networking.hostName = "nine";

  secrets.id.file             = ./id.age;
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
      extraGroups                 = [ "wheel" ];
    };

    backup = {
      description                 = "Backup";
      openssh.authorizedKeys.keys = keys.all;
      hashedPasswordFile          = config.secrets.sevenPassword.path;
    };
  };

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
