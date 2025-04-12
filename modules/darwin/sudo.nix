{ lib, ... }: let
  inherit (lib) enabled;
in {
  security.pam.services.sudo_local = enabled {
    touchIdAuth = true;
  };
}
