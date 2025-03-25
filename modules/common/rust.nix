{ lib, pkgs, ... }: let
  inherit (lib) attrValues;
in {
  environment.variables.CARGO_NET_GIT_FETCH_WITH_CLI = "true";

  environment.systemPackages = attrValues {
    inherit (pkgs)
      cargo-expand
      cargo-fuzz

      evcxr

      taplo
    ;

    fenix = pkgs.fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ];
  };
}
