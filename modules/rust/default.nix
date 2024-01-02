{ inputs, ulib, pkgs, ... }: with ulib; merge

(desktopSystemConfiguration {
  nixpkgs.overlays = [ inputs.fenix.overlays.default ];
})

(desktopSystemPackages (with pkgs; [
  (fenix.complete.withComponents [
    "cargo"
    "clippy"
    "rust-src"
    "rustc"
    "rustfmt"
  ])
]))
