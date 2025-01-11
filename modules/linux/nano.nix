{ lib, ... }: let
  inherit (lib) disabled;
in {
  environment.defaultPackages = [];

  programs.nano = disabled; # Garbage.
}
