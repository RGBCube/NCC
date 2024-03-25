{ inputs, lib, ulib, upkgs, ... }: with ulib; merge

(homeConfiguration {
  programs.nushell = {
    shellAliases.ns = "nix shell";

    configFile.text = lib.mkAfter ''
      def --wrapped nr [program: string = "", ...arguments] {
        nix run $program -- ...$arguments
      }
    '';
  };
})

(systemConfiguration {
  environment.etc."flakes".text = builtins.toJSON inputs;

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

    registry = {
      default.flake = inputs.nixpkgs;
    } // builtins.mapAttrs (_: value: lib.mkIf (lib.isType "flake" value) {
      flake = value;
    }) inputs;

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
      builders-use-substitutes  = true;
      flake-registry            = ""; # I DON'T WANT THE GLOBAL REGISTRY!!!
      http-connections          = 50;
      trusted-users             = [ "root" "@wheel" ];
      use-cgroups               = true;
      warn-dirty                = false;
    };
  };

  programs.nix-ld = enabled {};
})
