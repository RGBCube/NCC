{ inputs, ulib, pkgs, ... }: with ulib; merge3

(desktopSystemConfiguration {
  nixpkgs.overlays = [ inputs.fenix.overlays.default ];
})

(desktopSystemPackages (with pkgs; [
  cargo-expand

  (fenix.complete.withComponents [
    "cargo"
    "clippy"
    "rust-src"
    "rustc"
    "rustfmt"
  ])
]))

(desktopHomeConfiguration {
  programs.nushell.environmentVariables.CARGO_NET_GIT_FETCH_WITH_CLI = ''"true"'';
})
