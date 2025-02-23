{ config, lib, ... }: let
  inherit (config.networking.defaultGateway) interface;
  inherit (lib) optionals;
in {
  networking.interfaces.${interface} = {
    ipv4.addresses = optionals (config.networking.ipv4.address != null) [{
      inherit (config.networking.ipv4) address prefixLength;
    }];

    ipv6.addresses = optionals (config.networking.ipv4.address != null)  [{
      inherit (config.networking.ipv6) address prefixLength;
    }];
  };
}
