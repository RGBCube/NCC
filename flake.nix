{
  description = "My NixOS configurations.";

  nixConfig = {
    extra-substituters          = ''
      https://nix-community.cachix.org/
      https://hyprland.cachix.org/
    '';

    extra-trusted-public-keys   = ''
      nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=
      hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=
    '';
  };

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    homeManager = {
      url                    = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    utils = {
      url = "github:numtide/flake-utils";
    };

    fenix = {
      url                    = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
  };

  outputs = { nixpkgs, homeManager, utils, fenix, hyprland, ... }: utils.lib.eachDefaultSystem (system: let
    lib = nixpkgs.lib;

    ulib = rec {
      recursiveUpdate3 = x: y: z: lib.recursiveUpdate x (lib.recursiveUpdate y z);

      imports = paths: {
        imports = paths;
      };

      enabled = attributes: attributes // {
        enable = true;
      };

      normalUser = attributes: attributes // {
        isNormalUser = true;
      };

      systemConfiguration = attributes: attributes;

      systemPackages = packages: systemConfiguration {
        environment.systemPackages = packages;
      };

      systemFonts = fonts: systemConfiguration {
        fonts.packages = fonts;
      };

      homeConfiguration = user: attributes: systemConfiguration {
        home-manager.users = builtins.foldl' lib.recursiveUpdate {} (builtins.map (user: {
          ${user} = attributes;
        }) (if builtins.isList user then user else [ user ]));
      };

      homePackages = user: packages: homeConfiguration user {
        home.packages = packages;
      };
    };

    defaultConfiguration = host: ulib.systemConfiguration {
      nix.gc = {
          automatic  = true;
          dates      = "daily";
          options    = "--delete-older-than 3d";
          persistent = true;
      };

      nix.nixPath                = [ "nixpkgs=${nixpkgs}" ];
      nix.registry.nixpkgs.flake = nixpkgs;

      nix.optimise.automatic = true;

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays           = [
        fenix.overlays.default
        hyprland.overlays.default
      ];

      environment.defaultPackages = [];

      boot.tmp.cleanOnBoot = true;

      networking.hostName = host;
      home-manager.useGlobalPkgs   = true;
      home-manager.useUserPackages = true;
    };

    specialArgs = ulib;

    importConfigurations = hosts: builtins.concatMap (host: {
      ${host} = lib.nixosSystem {
        inherit specialArgs;

        modules = [
          homeManager.nixosModules.default
          (defaultConfiguration host)
          ./machines/${host}
        ];
      };
    }) hosts;
  in {
    nixosConfigurations = importConfigurations [
      "enka"
    ];
  });
}
