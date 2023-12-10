{ inputs, ulib, pkgs, ... }: with ulib; merge

(systemConfiguration {
  nixpkgs.overlays = [ inputs.fenix.overlays.default ];
})

(systemPackages (with pkgs; [
  (fenix.complete.withComponents [
    "cargo"
    "clippy"
    "rust-src"
    "rustc"
    "rustfmt"
  ])
]))
