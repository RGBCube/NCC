{ ... }:

{
  sound.enable = true;
  services.pipewire.enable = true;
  services.pipewire = {
    pulse.enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;
  };

  security.rtkit.enable = true; # Needed for PulseAudio.
}
