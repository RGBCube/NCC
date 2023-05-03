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

#    plasma-manager = {
#      url = "github:pjones/plasma-manager"; # Add "inputs.plasma-manager.homeManagerModules.plasma-manager" to the home-manager.users.${user}.imports
#      inputs.nixpkgs.follows = "nixpkgs";
#      inputs.home-manager.follows = "home-manager";
#    };
  };

  outputs = {
    nixpkgs,
    home-manager,
#    plasma-manager,
    ...
  }:
  let
    lib = nixpkgs.lib;

    importConfiguration = directory: lib.nixosSystem {
      specialArgs = {
        inherit lib; # plasma-manager;

        pkgs = import nixpkgs {
          config.allowUnfree = true;
        };

        homeManagerConfiguration = attrs:
        let
          userName = import (directory + "user-name.nix");
        in
        {
          home-manager.users.${userName} = attrs;
        };
      };

      nixosConfigurations.${basename directory} = {
        modules = [
          directory
          {
            networking.hostName = basename directory;
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
    };
  in
  builtins.foldl lib.recursiveUpdate (builtins.map importConfiguration (builtins.readDir ./machines));
}
