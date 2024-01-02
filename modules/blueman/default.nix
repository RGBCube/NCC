{ ulib, ... }: with ulib;

desktopSystemConfiguration {
  services.blueman = enabled {};

  hardware.bluetooth = enabled {
    powerOnBoot = true;
  };
}
