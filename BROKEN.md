# Broken Stuff

- Not broken either but set up Nextcloud exporters.

- Some Nginx headers were commented out because it collided or something.
  Idfk. Make them not. Uncomment.

- Discord does not use Wayland.

- QT theme doesn't work.

- Nushell custom prompt title does not work, as it gets
  overriden by the shell integration in a split second.

- Nix Super errors, saying it expected an attrset and got a
  trunk when evaluating the non-outputs section. This should
  work, as it is an advertised feature (And it does! Don't get
  me wrong, it works if you don't use the builtins namespace)
  but doesn't work completely. Max is working on a fix, so I've
  put the soon-to-be attributes here, so I don't forget.

  ```nix
  nixConfig = with builtins; mapAttrs (name: concatStringsSep " ") {
    extra-substituters = [
      "https://nix-community.cachix.org/"
      "https://hyprland.cachix.org/"
      "https://cache.privatevoid.net/"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
    ];
  };

  inputs = with builtins; mapAttrs (name: url: {
    url = "git+https://${url}";
  } // (if elem name [ "nixSuper" "hyprland" "hyprpicker" ] then {} else {
    inputs.nixpkgs.follows = "nixpkgs";
  })) {
    nixSuper    = "github.com/privatevoid-net/nix-super";
    nixpkgs     = "github.com/NixOS/nixpkgs/tree/nixos-unstable";
    homeManager = "github.com/nix-community/home-manager";
    hyprland    = "github.com/hyprwm/Hyprland";
    hyprpicker  = "github.com/hyprwm/hyprpicker";
    fenix       = "github.com/nix-community/fenix";
    tools       = "github.com/RGBCube/FlakeTools";
    themes      = "github.com/RGBCube/ThemeNix";
  };
  ```
