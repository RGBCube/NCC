{ config, lib, ... }: let
  inherit (lib) enabled merge mkIf;
in merge <| mkIf config.isDesktop {
  security.rtkit = enabled;

  services.pipewire = enabled {
    alsa  = enabled { support32Bit = true; };
    pulse = enabled;
  };
}

