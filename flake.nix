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

  outputs = { nixpkgs, home-manager, fenix, ... }: let
    machines = [
      ./machines/asus
    ];

    nixosSystem = arguments: modules: nixpkgs.lib.nixosSystem {
      specialArgs = arguments;
      modules = modules;
    };

    importConfiguration = configurationDirectory: let
      hostName = builtins.baseNameOf configurationDirectory;
      hostPlatform = import (configurationDirectory + "/platform.nix");
    in {
      nixosConfigurations.${hostName} = nixosSystem {
        lib = nixpkgs.lib;

        pkgs = import nixpkgs {
          system = hostPlatform;
          config.allowUnfree = true;

          overlays = [
            fenix.overlays.default
          ];
        };

        # SYSTEM
        systemConfiguration = attributes: attributes;

        systemPackages = packages: {
          environment.systemPackages = packages;
        };

        systemFonts = fonts: {
          fonts.fonts = fonts;
        };

        # HOME
        homeConfiguration = userName: attributes: {
          home-manager.users.${userName} = attributes;
        };

        homePackages = userName: packages: {
          home-manager.users.${userName}.home.packages = packages;
        };

        # GENERAL
        imports = importPaths: {
          imports = importPaths;
        };

        enabled = attributes: attributes // {
          enable = true;
        };

        normalUser = attributes: attributes // {
          isNormalUser = true;
        };
      } [
        configurationDirectory
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
  in builtins.foldl' nixpkgs.lib.recursiveUpdate {} (builtins.map importConfiguration machines);
}
