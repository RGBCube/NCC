{
  description = "RGBCube's Configuration Collection";

  nixConfig = {
    extra-substituters = [
      "https://cache.garnix.io/"
      "https://hyprland.cachix.org/"
      "https://nix-community.cachix.org/"
    ];

    extra-trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    experimental-features = [
      "cgroups"
      "flakes"
      "nix-command"
      "pipe-operators"
    ];

    accept-flake-config      = true;
    builders-use-substitutes = true;
    flake-registry           = "";
    http-connections         = 50;
    show-trace               = true;
    trusted-users            = [ "root" "@wheel" "@admin" ];
    use-cgroups              = true;
    warn-dirty               = false;
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";

      inputs.nixpkgs.follows      = "nixpkgs";
      inputs.darwin.follows       = "nix-darwin";
      inputs.home-manager.follows = "home-manager";
    };

    fenix.url = "github:nix-community/fenix";

    # nix.url = "github:NixOS/nix";
    nil.url = "github:oxalica/nil";

    jj = {
      url = "github:jj-vcs/jj";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    crash = {
      url = "github:RGBCube/crash";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    themes.url = "github:RGBCube/ThemeNix";
  };

  outputs = inputs @ { nixpkgs, nix-darwin, ... }: let
    inherit (builtins) readDir;
    inherit (nixpkgs.lib) attrsToList const groupBy listToAttrs mapAttrs;

    lib'' = nixpkgs.lib.extend (_: _: nix-darwin.lib);
    lib'  = lib''.extend (_: _: builtins);
    lib   = lib'.extend <| import ./lib inputs;

    hostsByType = readDir ./hosts
      |> mapAttrs (name: const <| import ./hosts/${name} lib)
      |> attrsToList
      |> groupBy ({ name, value }:
        if value ? class && value.class == "nixos" then
          "nixosConfigurations"
        else
          "darwinConfigurations")
      |> mapAttrs (const listToAttrs);
  in hostsByType // {
    inherit lib;
  };
}
