{ lib, ... }: let
  inherit (lib) enabled;
in {
  services.aerospace = enabled {
  };
}
