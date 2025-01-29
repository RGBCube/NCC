{ lib, ... }: let
  inherit (lib) enabled disabled;
in {
  documentation = {
    doc  = disabled;
    info = disabled;

    man = enabled {
      generateCaches = true;
    };
  };
}
