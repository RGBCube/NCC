{ config, lib, ... }: let
  inherit (lib) enabled concatStringsSep;
in {
  services.resolved = enabled {
    dnssec     = "true";
    dnsovertls = "true";

    extraConfig = config.networking.dns.servers
      |> map (server: "DNS=${server}")
      |> concatStringsSep "\n";

    fallbackDns = config.networking.dns.serversFallback;
  };
}
