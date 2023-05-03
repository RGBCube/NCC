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
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }:
  let
    importConfiguration = directory:

     let
       hostPlatform = import (directory + "/platform.nix");
       # The folder name is the host name of the machine.
       hostName = builtins.baseNameOf directory;
       userName = import (directory + "/username.nix");
     in

     {
      nixosConfigurations.${hostName} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          lib =  nixpkgs.lib;

          pkgs = import nixpkgs {
            system = hostPlatform;
            config.allowUnfree = true;
          };

          # Helper function for DRY.
          homeManagerConfiguration = attrs: {
            home-manager.users.${userName} = attrs;
          };
        };

        modules = [
          directory
          home-manager.nixosModules.home-manager

          # Extra configuration derived from the metadata.
          {
            networking.hostName = builtins.baseNameOf directory;
            nixpkgs.hostPlatform = hostPlatform;

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
    };
  in
  # Basically imports all machines in ./machines/.
  builtins.foldl' nixpkgs.lib.recursiveUpdate {} (builtins.map importConfiguration [
    ./machines/asus # HACK: Use a function to list the directory.
  ]);
}
