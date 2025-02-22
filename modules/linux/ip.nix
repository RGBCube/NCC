{ config, lib, ... }: let
  inherit (config.networking.defaultGateway) interface;
  inherit (lib) optionals;
in {
  networking.interfaces.${interface} = {
    ipv4.addresses = optionals (config.networking.ipv4 != null) [{
      address      = config.networking.ipv4;
      prefixLength = 22;
    }];

    ipv6.addresses = optionals (config.networking.ipv4 != null)  [{
      address      = config.networking.ipv6;
      prefixLength = 64;
    }];
  };
}
