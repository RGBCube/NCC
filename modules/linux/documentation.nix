{ lib, ... }: let
  inherit (lib) disabled enabled;
in {
  documentation = {
    doc  = disabled;
    info = disabled;
    man  = enabled;
  };
}
