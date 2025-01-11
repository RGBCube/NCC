{ lib, ... }: let
  inherit (lib) enabled;
in {
  environment.shellAliases.ts = "sudo tailscale";

  services.tailscale = enabled;
}
