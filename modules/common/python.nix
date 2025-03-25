{ lib, pkgs, ... }: let
  inherit (lib) attrValues;
in {
  environment.systemPackages = attrValues {
    inherit (pkgs)
      python314
      uv
    ;
  };
}
