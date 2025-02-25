{ lib, ... }: let
  inherit (lib) disabled;
in {
  documentation = {
    doc  = disabled;
    info = disabled;
    man  = disabled;
  };
}
