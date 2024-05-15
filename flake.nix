{
  description = "RGBCube's NixOS Configuration Collection";

  nixConfig = {
    extra-substituters = [
      "https://cache.garnix.io/"
      "https://ghostty.cachix.org/"
      "https://hyprland.cachix.org/"
      "https://nix-community.cachix.org/"
    ];

    extra-trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    homeManager = {
      url = "github:nix-community/home-manager";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    ageNix = {
      url = "github:ryantm/agenix";

      inputs.nixpkgs.follows      = "nixpkgs";
      inputs.home-manager.follows = "homeManager";
    };

    crash = {
      url = "github:RGBCube/crash";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    simpleMail = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url   = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprpicker.url = "github:hyprwm/hyprpicker";

    ghostty.url       = "git+ssh://git@github.com/RGBCube/ghostty";
    ghosttyModule.url = "github:clo4/ghostty-hm-module";

    fenix.url = "github:nix-community/fenix";

    zig = {
      url = "github:mitchellh/zig-overlay";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    zls = {
      url = "github:zigtools/zls/master";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    themes.url = "github:RGBCube/ThemeNix";
  };

  outputs = { self, nixpkgs, ... } @ inputs: let
    lib0  = nixpkgs.lib;
    keys = import ./keys.nix;

    collectNixFiles = directory: with lib0; pipe (builtins.readDir directory) [
      (mapAttrsToList (name: type: let
        path = /${directory}/${name};
      in if type == "directory" then
        collectNixFiles path
      else
        path))
      flatten
      (filter (hasSuffix ".nix"))
      (filter (name: !hasPrefix "_" (builtins.baseNameOf name)))
    ];

    lib1 = with lib0; extend (_: _: pipe (collectNixFiles ./lib) [
      (map (file: import file lib0))
      (filter (thunk: !isFunction thunk))
      (foldl' recursiveUpdate {})
    ]);

    nixpkgsOverlayModule = with lib1; {
      nixpkgs.overlays = [(final: prev: {
        ghostty = inputs.ghostty.packages.${prev.system}.default;
        zls     = inputs.zls.packages.${prev.system}.default;
      })] ++ pipe inputs [
        attrValues
        (filter (value: value ? overlays.default))
        (map (value: value.overlays.default))
      ];

      nixpkgs.config.allowUnfree = true; # IDGAF anymore.
    };

    homeManagerModule = { lib, ... }: with lib; {
      home-manager.users = genAttrs allNormalUsers (_: {});

      home-manager.useGlobalPkgs   = true;
      home-manager.useUserPackages = true;

      home-manager.sharedModules = pipe inputs [
        attrValues
        (filter (value: value ? homeModules.default))
        (map (value: value.homeModules.default))
      ];
    };

    optionModules = with lib1; [
      (lib1.mkAliasOptionModule [ "secrets" ] [ "age" "secrets" ])
    ] ++ collectNixFiles ./options ++ pipe inputs [
      attrValues
      (filter (value: value ? nixosModules.default))
      (map (value: value.nixosModules.default))
    ];

    optionUsageModules = [
      nixpkgsOverlayModule
      homeManagerModule
    ] ++ collectNixFiles ./modules;

    specialArgs = inputs // { inherit inputs keys; };

    hosts = lib1.pipe (builtins.readDir ./hosts) [
      (lib1.filterAttrs (name: type: type == "regular" -> lib1.hasSuffix ".nix" name))
      lib1.attrNames
    ];

    lib2s = with lib1; genAttrs hosts (name: let
      hostStub = nixosSystem {
        inherit specialArgs;

        modules = [ ./hosts/${name} ] ++ optionModules;
      };
    in extend (_: _: pipe (collectNixFiles ./lib) [
      (map (file: import file lib1))
      (filter (isFunction))
      (map (func: func hostStub.config))
      (foldl' recursiveUpdate {})
    ]));

    configurations = lib1.genAttrs hosts (name: lib2s.${name}.nixosSystem {
      inherit specialArgs;
 
      modules = [{
        networking.hostName = name;
      }] ++ optionModules ++ optionUsageModules ++ collectNixFiles ./hosts/${name};
    });
  in {
    nixosConfigurations = configurations;

  # This is here so we can do self.<whatever> instead of self.nixosConfigurations.<whatever>.config.
  } // lib1.mapAttrs (_: value: value.config) configurations;
}
