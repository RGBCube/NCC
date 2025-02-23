{ config, lib, ... }: let
  inherit (lib) enabled merge mkIf;
in merge <| mkIf config.isDesktop {
  services.blueman = enabled;

  hardware.bluetooth = enabled {
    powerOnBoot = true;
  };
}
