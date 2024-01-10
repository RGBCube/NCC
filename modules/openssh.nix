{ ulib, ... }: with ulib;

serverSystemConfiguration {
  services.openssh = enabled {
    banner   = "Welcome to RGBCube's server!\n";
    ports    = [ 2222 ];
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication       = false;
    };
  };
}
