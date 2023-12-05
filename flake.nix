{
  description = "My NixOS configurations.";

  nixConfig = {
    extra-substituters = ''
      https://nix-community.cachix.org/
      https://hyprland.cachix.org/
    '';

    extra-trusted-public-keys = ''
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

    tools = {
      url                    = "github:RGBCube/FlakeTools";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    themes = {
      url = "github:RGBCube/ThemeNix";
    };

    fenix = {
      url                    = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
    };
  };

  outputs = { nixpkgs, homeManager, tools, themes, fenix, ... } @ inputs: tools.eachDefaultLinuxArch (system: let
    pkgs = nixpkgs.legacyPackages.${system};

    upkgs = {
      theme = themes.custom (themes.raw.gruvbox-dark-hard // {
        corner-radius = 12;
        border-width  = 3;

        font.size.normal = 12;
        font.size.big    = 18;

        font.sans.name    = "Lexend";
        font.sans.package = pkgs.lexend;

        font.mono.name    = "RobotoMono Nerd Font";
        font.mono.package = (pkgs.nerdfonts.override {
          fonts = [
            "RobotoMono"
          ];
        });

        icons.name    = "Gruvbox-Plus-Dark";
        icons.package = pkgs.callPackage (import ./devirations/gruvbox-icons.nix) {};
      });

      hyprland = inputs.hyprland.packages.${system}.default;
      hyprpicker = inputs.hyprpicker.packages.${system}.default;
    };

    lib = nixpkgs.lib;

    ulib = {
      inherit (tools) recursiveUpdateMap;

      recursiveUpdate3 = x: y: z: lib.recursiveUpdate x (lib.recursiveUpdate y z);
    };

    abstractions = rec {
      importAll = paths: {
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

    defaultConfiguration = host: with abstractions; systemConfiguration {
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

      nix.settings.trusted-users = [
        "root"
        "@wheel"
      ];

      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays           = [ fenix.overlays.default ];

      programs.nix-ld = enabled {};

      environment.defaultPackages = [];

      boot.tmp.cleanOnBoot = true;

      networking.hostName = host;
      home-manager.useGlobalPkgs   = true;
      home-manager.useUserPackages = true;
    };

    specialArgs = abstractions // {
      inherit upkgs ulib;
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
