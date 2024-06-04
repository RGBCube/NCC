{ lib, ... }: with lib;

let
  # Shorter is better for networking interfaces IMO.
  interface = "ts0";
in systemConfiguration {
  environment.shellAliases.ts = "sudo tailscale";

  # This doesn't work with dig but works with curl, Firefox
  # and all other tools. Skill issue.
  services.resolved.domains = [ "warthog-major.ts.net" ];

  services.tailscale = enabled {
    interfaceName      = interface;
    useRoutingFeatures = "both";
  };

  # Breaks with tailscale.
  systemd.services.NetworkManager-wait-online = disabled;

  networking.firewall.trustedInterfaces = [ interface ];
}
