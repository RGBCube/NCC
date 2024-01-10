{ ulib, ... }: with ulib;

desktopSystemConfiguration {
  security.rtkit = enabled {};
  sound          = enabled {};

  services.pipewire = enabled {
    alsa  = enabled { support32Bit = true; };
    pulse = enabled {};
  };
}
