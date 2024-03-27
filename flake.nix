{
  description = "RGBCube's NixOS Configuration Collection";

  nixConfig = {
    extra-substituters        = "https://cache.garnix.io/";
    extra-trusted-public-keys = "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    nixSuper = {
      url = "github:privatevoid-net/nix-super";

      inputs.flake-compat.follows = "flakeCompat";
      # inputs.nixpkgs.follows      = "nixpkgs";
    };

    homeManager = {
      url = "github:nix-community/home-manager";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    ageNix = {
      url = "github:ryantm/agenix";

      inputs.nixpkgs.follows      = "nixpkgs";
      inputs.home-manager.follows = "homeManager";
    };

    nuScripts = {
      url   = "github:nushell/nu_scripts";
      flake = false;
    };

    simpleMail = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";

      inputs.nixpkgs.follows      = "nixpkgs";
      inputs.utils.follows        = "flakeUtils";
      inputs.flake-compat.follows = "flakeCompat";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";

      inputs.hyprlang.follows = "hyprlang";
      inputs.nixpkgs.follows  = "nixpkgs";
      inputs.systems.follows  = "systems";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";

      inputs.nixpkgs.follows  = "nixpkgs";
    };

    ghostty = {
      url = "git+ssh://git@github.com/RGBCube/ghostty";

      inputs.nixpkgs-unstable.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows   = "nixpkgs";

      inputs.zig.follows = "zig";
      inputs.zls.follows = "zig";
    };

    fenix = {
      url = "github:nix-community/fenix";

      inputs.nixpkgs.follows      = "nixpkgs";
    };

    zig = {
      url = "github:mitchellh/zig-overlay";

      inputs.nixpkgs.follows      = "nixpkgs";
      inputs.flake-utils.follows  = "flakeUtils";
      inputs.flake-compat.follows = "flakeCompat";
    };

    zls = {
      url = "github:zigtools/zls/master";

      inputs.nixpkgs.follows     = "nixpkgs";
      inputs.flake-utils.follows = "flakeUtils";
      inputs.zig-overlay.follows = "zig";
    };

    ghosttyModule.url = "github:clo4/ghostty-hm-module";

    themes.url = "github:RGBCube/ThemeNix";

    # I don't use these, but I place them here and make the other
    # inputs follow them, so I get much less duplicate code pulled in.
    flakeUtils = {
      url = "github:numtide/flake-utils";

      inputs.systems.follows = "systems";
    };

    flakeCompat = {
      url   = "github:edolstra/flake-compat";
      flake = false;
    };

    systems.url = "github:nix-systems/default";

    hyprlang = {
      url = "github:hyprwm/hyprlang";

      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
  };

  outputs = {
    nixpkgs,
    ageNix,
    simpleMail,
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
          [ "nixSuper" "ageNix" "hyprland" "hyprpicker" "ghostty" "zls" ]
          (name: inputs.${name}.packages.${system}.default);

        other = {
          nuScripts = inputs.nuScripts;
          rat       = pkgs.callPackage ./derivations/rat.nix {};
          zig       = inputs.zig.packages.${system}.master;
        };
      in defaults // other;

      keys = import ./keys.nix;

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

        nullIfUnderscoreOrNotNix = name: if (builtins.substring 0 1 name) == "_" then
          null
        else if lib.hasSuffix ".age" name then
          null
        else
          name;

        filterNull = builtins.filter (x: x != null);

        importDirectory = directory:
          filterNull (mapDirectory (name: _: lib.mapNullable (name: /${directory}/${name}) (nullIfUnderscoreOrNotNix name)) directory);
      in [
        homeManager.nixosModules.default

        ageNix.nixosModules.default

        simpleMail.nixosModules.default

        defaultConfiguration
      ] ++ (importDirectory ./hosts/${host})
        ++ (importDirectory ./modules);
    };

    hosts = (builtins.attrNames (builtins.readDir ./hosts));
  in {
    nixosConfigurations = nixpkgs.lib.genAttrs hosts importConfiguration;
  };
}
