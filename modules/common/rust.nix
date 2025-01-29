{ pkgs, ... }: {
  environment.variables.CARGO_NET_GIT_FETCH_WITH_CLI = "true";

  environment.systemPackages = [
    pkgs.cargo-expand
    pkgs.cargo-fuzz

    pkgs.evcxr

    (pkgs.fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
  ];
}
