{ ulib, ... }: with ulib;

systemConfiguration {
  services.blueman = enabled {};

  hardware.bluetooth = enabled {
    powerOnBoot = true;
  };
}
