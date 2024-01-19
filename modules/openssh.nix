{ ulib, ... }: with ulib;

serverSystemConfiguration {
  programs.mosh = enabled {
    openFirewall = true;
  };

  services.openssh = enabled {
    banner   = "Welcome to RGBCube's server!\n";
    ports    = [ 2222 ];
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication       = false;
    };
  };
}
