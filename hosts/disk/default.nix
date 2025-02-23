lib: lib.nixosSystem ({ config, keys, lib, ... }: let
  inherit (lib) collectNix remove;
in {
  imports = collectNix ./. |> remove ./default.nix;

  secrets.id.file           = ./id.age;
  services.openssh.hostKeys = [{
    type = "ed25519";
    path = config.secrets.id.path;
  }];

  secrets.floppyPassword.file = ./password.floppy.age;
  users.users                 = {
    root.hashedPasswordFile = config.secrets.floppyPassword.path;

    floppy = {
      description                 = "Floppy";
      openssh.authorizedKeys.keys = keys.admins;
      hashedPasswordFile          = config.secrets.floppyPassword.path;
      isNormalUser                = true;
      extraGroups                 = [ "wheel" ];
    };

    backup = {
      description                 = "Backup";
      openssh.authorizedKeys.keys = keys.all;
      hashedPasswordFile          = config.secrets.floppyPassword.path;
      isNormalUser                = true;
    };
  };

  home-manager.users = {
    root   = {};
    floppy = {};
    backup = {};
  };

  networking = let
    interface = "ens32";
  in {
    hostName = "disk";

    ipv4.address = "23.164.232.40";
    ipv6.address = "2602:f9f7::40";

    domain = "rgbcu.be";

    defaultGateway = {
      inherit interface;

      address = "23.164.232.1";
    };

    defaultGateway6 = {
      inherit interface;

      address = "2602:f9f7::1";
    };
  };

  nixpkgs.hostPlatform       = "x86_64-linux";
  system.stateVersion        = "23.11";
  home-manager.sharedModules = [{
    home.stateVersion = "23.11";
  }];
})
