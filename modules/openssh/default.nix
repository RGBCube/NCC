{ ulib, ... }: with ulib;

serverSystemConfiguration {
  services.openssh = enabled {
    banner   = "Welcome to RGBCube's server!";
    ports    = [ 2222 ];
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication       = false;
    };
  };
}
