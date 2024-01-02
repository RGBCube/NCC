{ ulib, ... }: with ulib;

serverSystemConfiguration {
  services.openssh = enabled {
    ports = [ 2222 ];
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication       = false;
    };
  };
}
