{ config, pkgs, lib, ... }: let
  inherit (lib) attrValues merge mkIf;
in merge <| mkIf config.isDesktop {
  # Steam uses 32-bit drivers for some unholy fucking reason.
  hardware.graphics.enable32Bit = true;

  environment.systemPackages = attrValues {
    inherit (pkgs)
      steam
    ;
  };
}
