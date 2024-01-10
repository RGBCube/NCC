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

    agenix = {
      url                    = "github:ryantm/agenix";
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
    agenix,
    homeManager,
    fenix,
    site,
    tools,
    themes,
    ...
  } @ inputs: let
    importConfiguration = host: let
      hostDefault = import ./hosts/${host} {
        config = {};
        keys   = {};
        ulib   = (import ./lib lib null) // {
          merge = lib.recursiveUpdate;
        };
      };

      users = {
        all = let
          users = builtins.attrNames hostDefault.users.users;
        in if builtins.elem "root" users then
          users
        else
          users ++ [ "root" ];

        graphical = builtins.attrNames (lib.filterAttrs (name: value: builtins.elem "graphical" (value.extraGroups or [])) hostDefault.users.users);
      };

      system = hostDefault.nixpkgs.hostPlatform;

      lib  = nixpkgs.lib;
      ulib = import ./lib lib users;

      pkgs  = import nixpkgs { inherit system; };
      upkgs = let
        defaults = lib.genAttrs
          [ "nixSuper" "agenix" "hyprland" "hyprpicker" "ghostty" "zls" ]
          (name: inputs.${name}.packages.${system}.default);

        other = {
          nuScripts = inputs.nuScripts;
          zig       = inputs.zig.packages.${system}.master;
        };
      in defaults // other;

      keys = import ./secrets/keys.nix;

      theme = themes.custom (themes.raw.gruvbox-dark-hard // {
        cornerRadius = 8;
        borderWidth  = 2;

        margin  = 6;
        padding = 8;

        font.size.normal = 12;
        font.size.big    = 18;

        font.sans.name    = "Lexend";
        font.sans.package = pkgs.lexend;

        font.mono.name    = "JetBrainsMono Nerd Font";
        font.mono.package = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });

        icons.name    = "Gruvbox-Plus-Dark";
        icons.package = pkgs.callPackage (import ./derivations/gruvbox-plus-icon-pack.nix) {};
      });

      defaultConfiguration = {
        age.identityPaths = builtins.map (user: "/home/${user}/.ssh/id") users.all;

        home-manager.users           = lib.genAttrs users.all (user: {});
        home-manager.useGlobalPkgs   = true;
        home-manager.useUserPackages = true;

        networking.hostName  = host;
      };

    in lib.nixosSystem {
      inherit system;

      specialArgs = { inherit inputs ulib upkgs keys theme; };
      modules     = [
        homeManager.nixosModules.default

        agenix.nixosModules.default
        ./secrets

        site.nixosModules.default

        defaultConfiguration
      ] ++ (builtins.attrValues (builtins.mapAttrs (name: type: ./modules/${name}) (builtins.readDir ./modules)))
        ++ (builtins.attrValues (builtins.mapAttrs (name: type: ./hosts/${host}/${name}) (builtins.readDir ./hosts/${host})));
    };

    hosts = (builtins.attrNames
      (nixpkgs.lib.filterAttrs
        (name: value: value == "directory")
        (builtins.readDir ./hosts)));
  in {
    nixosConfigurations = nixpkgs.lib.genAttrs hosts importConfiguration;
  };
}
