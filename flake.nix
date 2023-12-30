{
  description = "All my NixOS configurations.";

  nixConfig = {
    extra-substituters = ''
      https://nix-community.cachix.org/
      https://hyprland.cachix.org/
      https://cache.privatevoid.net/
      https://cache.garnix.io/
    '';

    extra-trusted-public-keys = ''
      nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=
      hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=
      cache.privatevoid.net-1:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg=
      cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=
    '';
  };

  inputs = {
    nixSuper = {
      url = "github:privatevoid-net/nix-super";
    };

    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    homeManager = {
      url                    = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
    };

    ghostty = {
      url = "git+ssh://git@github.com/RGBCube/GHostty";
    };

    ghosttyModule = {
      url = "github:clo4/ghostty-hm-module";
    };

    nuScripts = {
      url   = "github:nushell/nu_scripts";
      flake = false;
    };

    fenix = {
      url                    = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zig = {
      url                    = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zls = {
      url                    = "github:zigtools/zls";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    site = {
      url                    = "github:RGBCube/Site";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tools = {
      url                    = "github:RGBCube/FlakeTools";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    themes = {
      url = "github:RGBCube/ThemeNix";
    };
  };

  outputs = {
    nixSuper,
    nixpkgs,
    homeManager,
    ghosttyModule,
    nuScripts,
    fenix,
    zig,
    site,
    tools,
    themes,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;

    configuration = host: {
      system,
      normalUsers,
      graphicalUsers ? [],
    }: let
      ulib = import ./lib lib normalUsers graphicalUsers;

      pkgs = import nixpkgs { inherit system; };

      upkgs = {
        inherit nuScripts;

        zig = zig.packages.${system}.master;
      } // (lib.genAttrs
        [ "nixSuper" "hyprland" "hyprpicker" "ghostty" "zls" ]
        (name: inputs.${name}.packages.${system}.default));

      theme = themes.custom (themes.raw.gruvbox-dark-hard // {
        corner-radius = 0;
        border-width  = 1;

        margin  = 0;
        padding = 8;

        font.size.normal = 12;
        font.size.big    = 18;

        font.sans.name    = "Lexend";
        font.sans.package = pkgs.lexend;

        font.mono.name    = "JetBrainsMono Nerd Font";
        font.mono.package = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });

        icons.name    = "Gruvbox-Plus-Dark";
        icons.package = pkgs.callPackage (import ./derivations/gruvbox-icons.nix) {};
      });

      defaultConfiguration = {
        environment.defaultPackages = [];

        home-manager.sharedModules   = [ ghosttyModule.homeModules.default ];
        home-manager.useGlobalPkgs   = true;
        home-manager.useUserPackages = true;

        networking.hostName  = host;
        nixpkgs.hostPlatform = system;
      };
    in lib.nixosSystem {
      inherit system;

      specialArgs = { inherit inputs ulib upkgs theme; };
      modules     = [
        homeManager.nixosModules.default
        site.nixosModules.default
        defaultConfiguration
        ./hosts/${host}
      ];
    };

    configurations = builtins.mapAttrs configuration;
  in {
    nixosConfigurations = configurations {
      enka = {
        system = "x86_64-linux";

        normalUsers    = [ "nixos" "root" ];
        graphicalUsers = [ "nixos" ];
      };

      cube = {
        system = "x86_64-linux";

        normalUsers = [ "rgb" "root" ];
      };
    };
  };
}
