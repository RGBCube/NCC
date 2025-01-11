{ config, lib, ... }: let
  inherit (lib) head map splitString;
in {
  # Yeah, no DNSSEC or DoT or anything.
  # That's what you get for using Darwin I guess.
  networking.dns = config.dnsServers
    |> map (splitString "#")
    |> map head;

  networking.knownNetworkServices = [
    "Thunderbolt Bridge"
    "Wi-Fi"
  ];
}
