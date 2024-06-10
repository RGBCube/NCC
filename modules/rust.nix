{ lib, pkgs, ... }: with lib; merge

(desktopSystemPackages (with pkgs; [
  cargo-expand
  cargo-fuzz

  evcxr

  (fenix.complete.withComponents [
    "cargo"
    "clippy"
    "rust-src"
    "rustc"
    "rustfmt"
  ])
]))

(desktopSystemConfiguration {
  environment.variables.CARGO_NET_GIT_FETCH_WITH_CLI = "true";
})

