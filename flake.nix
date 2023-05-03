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
    lib = nixpkgs.lib;

    importConfiguration = directory: {
      nixosConfigurations.${builtins.baseNameOf directory} =
      let
        hostPlatform = import (directory + "/platform.nix");
      in
      lib.nixosSystem {
        specialArgs = {
          inherit lib;

          pkgs = import nixpkgs {
            system = hostPlatform;
            config.allowUnfree = true;
          };

          homeManagerConfiguration = attrs: {
            home-manager.users.${import (directory + "/username.nix")} = attrs;
          };
        };

        modules = [
          directory
          {
            networking.hostName = builtins.baseNameOf directory;
            nixpkgs.hostPlatform = hostPlatform;
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
  builtins.foldl' lib.recursiveUpdate {} (builtins.map importConfiguration [
    ./machines/asus # HACK: Use a function to list the directory.
  ]);
}
