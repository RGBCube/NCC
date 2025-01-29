{ config, lib, ... }: let
  inherit (lib) optionalString;
in {
  environment.shellAliases.ts = "${optionalString config.isLinux "sudo "}tailscale";
}
