{ inputs, lib, ulib, upkgs, ... }: with ulib;

systemConfiguration {
  nix = {
    gc = {
      automatic  = true;
      dates      = "daily";
      options    = "--delete-older-than 3d";
      persistent = true;
    };

    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    optimise.automatic = true;

    package = upkgs.nixSuper;

    registry = (builtins.mapAttrs
      (_: value: lib.mkIf (value ? sourceInfo) {
        flake = value;
      }) inputs) // { default.flake = inputs.nixpkgs; };

    settings.experimental-features = [
      "auto-allocate-uids"
      "ca-derivations"
      "cgroups"
      "configurable-impure-env"
      "flakes"
      "git-hashing"
      "nix-command"
      "recursive-nix"
      "repl-flake"
      "verified-fetches"
    ];

    settings = {
      accept-flake-config       = true;
      builders-use-substitutes = true;
      http-connections          = 50;
      trusted-users             = [ "root" "@wheel" ];
      use-cgroups               = true;
      warn-dirty                = false;
    };
  };

  programs.nix-ld = enabled {};
}
