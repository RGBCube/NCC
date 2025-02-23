{ lib, ... }: let
  inherit (lib) mkValue;
in {
  options.networking = {
    ipv4.address      = mkValue null;
    ipv4.prefixLength = mkValue 22;

    ipv6.address      = mkValue null;
    ipv6.prefixLength = mkValue 64;
  };
}
