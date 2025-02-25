lib: lib.nixosSystem ({ config, keys, lib, ... }: let
  inherit (lib) collectNix remove;
in {
  imports = collectNix ./. |> remove ./default.nix;

  secrets.id.file           = ./id.age;
  services.openssh.hostKeys = [{
    type = "ed25519";
    path = config.secrets.id.path;
  }];

  services.openssh.banner = ''
     _______________________________________
    / If God doesn't destroy San Francisco, \
    | He should apologize to Sodom and      |
    \ Gomorrah.                             /
     ---------------------------------------
            \   ^__^
             \  (oo)\_______
                (__)\       )\/\
                    ||----w |
                    ||     ||
  '';

  secrets.rgbPassword.file = ./password.rgb.age;
  users.users              = {
    root.hashedPasswordFile = config.secrets.rgbPassword.path;

    rgb = {
      description                 = "RGB";
      openssh.authorizedKeys.keys = keys.admins;
      hashedPasswordFile          = config.secrets.rgbPassword.path;
      isNormalUser                = true;
      extraGroups                 = [ "wheel" ];
    };

    backup = {
      description                 = "Backup";
      openssh.authorizedKeys.keys = keys.all;
      hashedPasswordFile          = config.secrets.rgbPassword.path;
      isNormalUser                = true;
    };
  };

  home-manager.users = {
    root   = {};
    rgb    = {};
    backup = {};
  };

  networking = let
    interface = "ens18";
  in {
    hostName = "cube";

    ipv4.address = "5.255.78.70";
    ipv4.prefixLength = 24;

    domain = "rgbcu.be";

    defaultGateway = {
      inherit interface;

      address = "5.255.78.1";
    };
  };

  system.stateVersion        = "23.05";
  home-manager.sharedModules = [{
    home.stateVersion = "23.11";
  }];
})
