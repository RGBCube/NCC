{ config, ulib, ... }: with ulib;

systemConfiguration {
  services.openssh = enabled {
    ports = if config.services.endlessh.enable then [ 2222 ] else [ 22 ];
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication       = false;
    };
  };
}
