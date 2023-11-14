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
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url                    = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url                    = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
  };

  outputs = { nixpkgs, home-manager, fenix, ... } @ inputs: let
    machines = [
      ./machines/enka
    ];

    architectures = [
      "x86_64-linux"
    ];

    lib = nixpkgs.lib // {
       recursiveUpdate3 = x: y: z: lib.recursiveUpdate x (lib.recursiveUpdate y z);
    };

    theme = import ./themes/gruvbox.nix;

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

    # SYSTEM
    systemConfiguration = attributes: attributes;

    systemPackages = packages: systemConfiguration {
      environment.systemPackages = packages;
    };

    systemFonts = fonts: systemConfiguration {
      fonts.packages = fonts;
    };

    # HOME
    homeConfiguration = userName: attributes: systemConfiguration {
      home-manager.users = builtins.foldl' lib.recursiveUpdate {} (builtins.map (userName: {
        ${userName} = attributes;
      }) (if builtins.isList userName then userName else [ userName ]));
    };

    homePackages = userName: packages: homeConfiguration userName {
      home.packages = packages;
    };

    importConfiguration = configurationDirectory: hostPlatform: let
      hostName = builtins.baseNameOf configurationDirectory;

      pkgs = import nixpkgs {
        system             = hostPlatform;
        config.allowUnfree = true;

        overlays = [
          fenix.overlays.default
        ];
      };

      hyprland = inputs.hyprland.packages.${hostPlatform}.hyprland;

      arguments = {
        inherit lib pkgs hyprland theme systemConfiguration systemPackages homeConfiguration systemFonts homePackages imports enabled normalUser;
      };

      defaultConfiguration = {
        nix.gc = {
            automatic  = true;
            dates      = "daily";
            options    = "--delete-older-than 3d";
            persistent = true;
        };

        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
        ];

        boot.tmp.cleanOnBoot = true;

        networking.hostName  = hostName;

        home-manager.useGlobalPkgs   = true;
        home-manager.useUserPackages = true;
      };

      modules = [
        home-manager.nixosModules.home-manager
        defaultConfiguration
        configurationDirectory
      ];
    in {
      nixosConfigurations.${hostName} = lib.nixosSystem {
        specialArgs = arguments;
        modules = modules;
      };
    };
  in builtins.foldl' lib.recursiveUpdate {} (builtins.concatMap (architecture: builtins.map (configuration: importConfiguration configuration architecture) machines) architectures);
}
