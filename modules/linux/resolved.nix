{ config, lib, ... }: let
  inherit (lib) enabled concatStringsSep map;
in {
  services.resolved = enabled {
    dnssec     = "true";
    dnsovertls = "true";

    extraConfig = config.dnsServers
      |> map (server: "DNS=${server}")
      |> concatStringsSep "\n";

    fallbackDns = config.fallbackDnsServers;
  };
}
