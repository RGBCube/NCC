{ lib, ... }: with lib;

let
  # Shorter is better for networking interfaces IMO.
  interface = "ts0";
in systemConfiguration {
  services.tailscale = enabled {
    interfaceName      = interface;
    useRoutingFeatures = "both";
  };

  networking.firewall.trustedInterfaces = [ interface ];
}
