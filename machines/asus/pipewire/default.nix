{ systemConfiguration, enabled, ... }:

systemConfiguration {
  security.rtkit = enabled {};
  sound = enabled {};

  services.pipewire = enabled {
    pulse = enabled {};

    alsa = enabled {
      support32Bit = true;
    };
  };
}
