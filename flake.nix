{
  description = "All my NixOS configurations.";

  # nixConfig = with builtins; mapAttrs (_: concatStringsSep " ") {
  #   extra-substituters = [
  #     "https://nix-community.cachix.org/"
  #     "https://hyprland.cachix.org/"
  #     "https://cache.privatevoid.net/"
  #   ];

  #   extra-trusted-public-keys = [
  #     "nix-community.cachix.org:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  #     "hyprland.cachix.org:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
  #     "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
  #   ];
  # };

  # inputs = with builtins; mapAttrs (name: url: {
  #   url = "git+https://${url}";
  # } // (if elem name [ "nixSuper" "hyprland" "hyprpicker" ] then {} else {
  #   inputs.nixpkgs.follows = "nixpkgs";
  # })) {
  #   nixSuper    = "github.com/privatevoid-net/nix-super";
  #   nixpkgs     = "github.com/NixOS/nixpkgs/tree/nixos-unstable";
  #   homeManager = "github.com/nix-community/home-manager";
  #   hyprland    = "github.com/hyprwm/Hyprland";
  #   hyprpicker  = "github.com/hyprwm/hyprpicker";
  #   fenix       = "github.com/nix-community/fenix";
  #   tools       = "github.com/RGBCube/FlakeTools";
  #   themes      = "github.com/RGBCube/ThemeNix";
  # };

  nixConfig = {
    extra-substituters = ''
      https://nix-community.cachix.org/
      https://hyprland.cachix.org/
      https://cache.privatevoid.net/
    '';

    extra-trusted-public-keys = ''
      nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=
      hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=
      cache.privatevoid.net-1:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg=
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

    fenix = {
      url                    = "github:nix-community/fenix";
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
    fenix,
    tools,
    themes,
    ...
  }: tools.eachDefaultLinuxArch (system: let
    pkgs = nixpkgs.legacyPackages.${system};

    upkgs = tools.recursiveUpdateMap (name: {
      ${name} = inputs.${name}.packages.${system}.default;
    }) [ "hyprland" "hyprpicker" ];

    lib = nixpkgs.lib;

    ulib = {
      inherit (tools) recursiveUpdateMap;

      recursiveUpdate3 = x: y: z: lib.recursiveUpdate x (lib.recursiveUpdate y z);
    };

    theme = themes.custom (themes.raw.gruvbox-dark-hard // {
      corner-radius = 12;
      border-width  = 3;

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
      nix.gc = {
        automatic  = true;
        dates      = "daily";
        options    = "--delete-older-than 3d";
        persistent = true;
      };

      nix.optimise.automatic = true;

      nix.nixPath = [ "nixpkgs=${nixpkgs}" ];

      nix.registry = {
        nixpkgs.flake = nixpkgs;
        default.flake = nixpkgs;
      };

      nix.settings.trusted-users = [ "root" "@wheel" ];

      nix.settings.warn-dirty = false;

      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays           = [
        fenix.overlays.default
        nixSuper.overlays.default
      ];

      programs.nix-ld = enabled {};

      environment.defaultPackages = [];

      boot.tmp.cleanOnBoot = true;

      networking.hostName = host;

      home-manager.useGlobalPkgs   = true;
      home-manager.useUserPackages = true;
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
