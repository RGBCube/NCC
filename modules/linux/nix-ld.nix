{ lib, ... }: let
  inherit (lib) enabled;
in {
  programs.nix-ld = enabled;
}
