{
  description = "All my NixOS configurations.";

  nixConfig = {
    extra-substituters = [
      "https://cache.garnix.io/"
      # "https://cache.privatevoid.net/"
      "https://ghostty.cachix.org/"
      "https://hyprland.cachix.org/"
      "https://nix-community.cachix.org/"
    ];

    extra-trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "cache.privatevoid.net-1:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
      "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
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

    mail = {
      url                    = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
    };

    ghostty = {
      url = "git+ssh://git@github.com/mitchellh/ghostty";
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

    themes = {
      url = "github:RGBCube/ThemeNix";
    };
  };

  outputs = {
    nixpkgs,
    agenix,
    mail,
    homeManager,
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

        graphical = builtins.attrNames (lib.filterAttrs (_: value: builtins.elem "graphical" (value.extraGroups or [])) hostDefault.users.users);
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
          rat       = pkgs.callPackage ./derivations/rat.nix {};
          zig       = inputs.zig.packages.${system}.master;
        };
      in defaults // other;

      keys = (import ./secrets/secrets.nix).keys;

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
        icons.package = pkgs.gruvbox-plus-icons;
      });

      defaultConfiguration = {
        age.identityPaths = map (user: "/home/${user}/.ssh/id") users.all;

        home-manager.users           = lib.genAttrs users.all (_: {});
        home-manager.useGlobalPkgs   = true;
        home-manager.useUserPackages = true;

        networking.hostName  = host;
      };

    in lib.nixosSystem {
      inherit system;

      specialArgs = { inherit inputs ulib upkgs keys theme; };

      modules = let
        mapDirectory = function: directory: with builtins;
          attrValues (mapAttrs function (readDir directory));

        nullIfUnderscore = name: if (builtins.substring 0 1 name) == "_" then
          null
        else
          name;

        filterNull = builtins.filter (x: x != null);

        importDirectory = directory:
          filterNull (mapDirectory (name: _: lib.mapNullable (name: /${directory}/${name}) (nullIfUnderscore name)) directory);
      in [
        homeManager.nixosModules.default

        agenix.nixosModules.default
        ./secrets

        mail.nixosModules.default

        defaultConfiguration
      ] ++ (importDirectory ./hosts/${host})
        ++ (importDirectory ./modules);
    };

    hosts = (builtins.attrNames (builtins.readDir ./hosts));
  in {
    nixosConfigurations = nixpkgs.lib.genAttrs hosts importConfiguration;
  };
}
