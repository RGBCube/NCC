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
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    nixSuper = {
      url = "github:privatevoid-net/nix-super";
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
      url = "git+ssh://git@github.com/RGBCube/Ghostty";
    };

    ghosttyModule = {
      url = "github:clo4/ghostty-hm-module";
    };

    nuScripts = {
      url   = "github:RGBCube/nu_scripts";
      flake = false;
    };

    fenix = {
      url                    = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zls = {
      url                    = "github:zigtools/zls";
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

  outputs = inputs @ {
    self,
    nixSuper,
    nixpkgs,
    homeManager,
    ghosttyModule,
    nuScripts,
    fenix,
    tools,
    themes,
    ...
  }: tools.eachDefaultLinuxArch (system: let
    pkgs = nixpkgs.legacyPackages.${system};

    upkgs = tools.recursiveUpdateMap (name: {
      ${name} = inputs.${name}.packages.${system}.default;
    }) [ "nixSuper" "hyprland" "hyprpicker" "ghostty" "zls" ];

    lib = nixpkgs.lib;

    ulib = {
      inherit (tools) recursiveUpdateMap;
      inherit nuScripts;

      recursiveUpdate3 = x: y: z: lib.recursiveUpdate x (lib.recursiveUpdate y z);
    };

    theme = themes.custom (themes.raw.gruvbox-dark-hard // {
      corner-radius = 0;
      border-width  = 1;

      margin  = 0;
      padding = 8;

      font.size.normal = 12;
      font.size.big    = 18;

      font.sans.name    = "Lexend";
      font.sans.package = pkgs.lexend;

      font.mono.name    = "RobotoMono Nerd Font";
      font.mono.package = (pkgs.nerdfonts.override { fonts = [ "RobotoMono" ]; });

      icons.name    = "Gruvbox-Plus-Dark";
      icons.package = pkgs.callPackage (import ./derivations/gruvbox-icons.nix) {};
    });

    abstractions = rec {
      imports = paths: lib.genAttrs [ "imports" ] (_: paths);

      enabled = attributes: attributes // { enable = true; };

      normalUser = attributes: attributes // { isNormalUser = true; };

      systemConfiguration = attributes: attributes;

      systemPackages = packages: systemConfiguration {
        environment.systemPackages = packages;
      };

      systemFonts = fonts: systemConfiguration {
        fonts.packages = fonts;
      };

      homeConfiguration = user: attributes: systemConfiguration {
        home-manager.users = tools.recursiveUpdateMap (user: {
          ${user} = attributes;
        }) (if builtins.isList user then user else [ user ]);
      };

      homePackages = user: packages: homeConfiguration user {
        home.packages = packages;
      };
    };

    defaultConfiguration = host: with abstractions; systemConfiguration {
      boot.tmp.cleanOnBoot = true;

      environment.defaultPackages = [];

      home-manager.sharedModules   = [ ghosttyModule.homeModules.default ];
      home-manager.useGlobalPkgs   = true;
      home-manager.useUserPackages = true;

      networking.hostName = host;

      nix.gc = {
        automatic  = true;
        dates      = "daily";
        options    = "--delete-older-than 3d";
        persistent = true;
      };

      nix.nixPath = [ "nixpkgs=${nixpkgs}" ];

      nix.optimise.automatic = true;

      nix.package = upkgs.nixSuper;

      nix.registry = {
        nixpkgs.flake = nixpkgs;
        default.flake = nixpkgs;
      };

      nix.settings.experimental-features = [
        "fetch-tree"
        "flakes"
        "nix-command"
        "repl-flake"
      ];

      nix.settings.trusted-users = [ "root" "@wheel" ];
      nix.settings.warn-dirty = false;

      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays           = [ fenix.overlays.default ];

      programs.nix-ld = enabled {};
    };

    specialArgs = abstractions // {
      inherit upkgs ulib theme;
    };

    importConfigurations = tools.recursiveUpdateMap (host: {
      nixosConfigurations.${host} = lib.nixosSystem {
        inherit specialArgs;

        modules = [
          homeManager.nixosModules.default
          (defaultConfiguration host)
          ./machines/${host}
        ];
      };
    });
  in importConfigurations [
    "enka"
  ]);
}
