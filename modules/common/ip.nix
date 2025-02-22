{ lib, ... }: let
  inherit (lib) mkValue;
in {
  options.networking = {
    ipv4 = mkValue null;
    ipv6 = mkValue null;
  };
}
