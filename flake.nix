{
  description = "My NixOS configuration.";

  nixConfig = {
    extra-experimental-features = ''
      nix-command
      flakes
    '';

    extra-substituters = "https://nix-community.cachix.org";
    extra-trusted-public-keys = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, fenix, ... }:

  with {
    importConfiguration = configDirectory:
    with {
      hostName = builtins.baseNameOf configDirectory;
      hostPlatform = import (configDirectory + "/platform.nix");
    };

    {
      nixosConfigurations.${hostName} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          lib = nixpkgs.lib;

          pkgs = import nixpkgs {
            system = hostPlatform;
            config.allowUnfree = true;

            overlays = [fenix.overlays.default];
          };

          # Helper function for DRY.
          homeManagerConfiguration = userName: attrs: {
            home-manager.users.${userName} = attrs;
          };
        };

        modules = [
          configDirectory
          home-manager.nixosModules.home-manager

          {
            nix.settings.experimental-features = [
              "nix-command"
              "flakes"
            ];

            networking.hostName = hostName;
            nixpkgs.hostPlatform = hostPlatform;

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
    };
  };

  builtins.foldl' nixpkgs.lib.recursiveUpdate {} (builtins.map importConfiguration [
    ./machines/asus # HACK: Use a function to list the directory.
  ]);
}
