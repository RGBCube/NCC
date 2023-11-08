{
  description = "My NixOS configuration.";

  nixConfig = {
    extra-experimental-features = ''
      nix-command
      flakes
    '';

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
    fenix = {
      url                    = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url                    = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { fenix, home-manager, hyprland, nixpkgs, ... }: let
    machines = [
      ./machines/enka
    ];

    architectures = [
      "x86_64-linux"
    ];

    nixosSystem = arguments: modules: nixpkgs.lib.nixosSystem {
      specialArgs = arguments;
      modules     = modules;
    };

    importConfiguration = configurationDirectory: hostPlatform: let
      hostName = builtins.baseNameOf configurationDirectory;
    in {
      nixosConfigurations.${hostName} = nixosSystem {
        lib = nixpkgs.lib // {
          recursiveUpdate3 = x: y: z: nixpkgs.lib.recursiveUpdate x (nixpkgs.lib.recursiveUpdate y z);
        };

        pkgs = import nixpkgs {
          system             = hostPlatform;
          config.allowUnfree = true;

          overlays = [
            fenix.overlays.default
          ];
        };

        hyprland = hyprland.packages.${hostPlatform}.hyprland;

        # SYSTEM
        systemConfiguration = attributes: attributes;

        systemPackages = packages: {
          environment.systemPackages = packages;
        };

        systemFonts = fonts: {
          fonts.packages = fonts;
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
          nix.gc.automatic                   = true;
          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];

          boot.tmp.cleanOnBoot = true;

          networking.hostName  = hostName;
          nixpkgs.hostPlatform = hostPlatform;

          home-manager.useGlobalPkgs   = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
  in builtins.foldl' nixpkgs.lib.recursiveUpdate {} (builtins.concatMap (architecture: builtins.map (configuration: importConfiguration configuration architecture) machines) architectures);
}
