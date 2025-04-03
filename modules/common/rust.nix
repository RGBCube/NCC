{ config, lib, pkgs, ... }: let
  inherit (lib) attrValues makeLibraryPath mkIf;
in {
  environment.variables = {
    CARGO_NET_GIT_FETCH_WITH_CLI = "true";

    LIBRARY_PATH = mkIf config.isDarwin <| makeLibraryPath <| attrValues {
      inherit (pkgs)
        libiconv
      ;
    };
  };

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
