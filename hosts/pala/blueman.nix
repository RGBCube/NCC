{ lib, ... }: with lib;

systemConfiguration {
  services.blueman = enabled;

  hardware.bluetooth = enabled {
    powerOnBoot = true;
  };
}
