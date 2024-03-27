{ lib, ... }: with lib;

desktopSystemConfiguration {
  services.blueman = enabled;

  hardware.bluetooth = enabled {
    powerOnBoot = true;
  };
}
